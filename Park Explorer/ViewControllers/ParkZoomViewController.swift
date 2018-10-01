//
//  ParkZoomViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/30/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

protocol ZoomDelegate {
    func dismiss()
}

class ParkZoomViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet var parkScrollView: UIScrollView!
    var delegate : ZoomDelegate?
    
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: image)
        let imageHeightScale = self.view.bounds.width/(image?.size.width)!
        let imageViewSize = CGSize(width: (image?.size.width)!*imageHeightScale, height: (image?.size.height)!*imageHeightScale)
        imageView.frame.size = imageViewSize
        parkScrollView.minimumZoomScale = 1.0
        parkScrollView.maximumZoomScale = 10.0
        parkScrollView.zoomScale = imageHeightScale
        parkScrollView.contentSize = self.view.bounds.size
        imageView.center = CGPoint(x: self.view.bounds.width/2.0, y: (self.view.bounds.height)/2.0)
        parkScrollView.addSubview(imageView)
        parkScrollView.delegate = self
    }
    
    func configure(_ image : UIImage){
        self.image = image
    }
    
    func centerForImage() -> CGPoint {
        // Center the image.
        let imageCenter = CGPoint(x: self.view.bounds.width/2.0, y: self.view.bounds.height/2.0)
        return imageCenter
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count > 0 {
            return scrollView.subviews[0]
        }
        return nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Update imageView center and if user is currently zoomed in on an image, disabling scrolling on mainScrollView
        if scrollView == parkScrollView{
            scrollView.subviews[0].center = centerForImage()
        }
        if scrollView.zoomScale == 1.0 {
            print("HIT")
            delegate?.dismiss()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let imageHeightScale = size.width/(image?.size.width)!
        let imageViewSize = CGSize(width: (image?.size.width)!*imageHeightScale, height: (image?.size.height)!*imageHeightScale)
        parkScrollView.subviews[0].frame.size = imageViewSize
        parkScrollView.minimumZoomScale = 1.0
        parkScrollView.maximumZoomScale = 10.0
        parkScrollView.zoomScale = imageHeightScale
        parkScrollView.contentSize = size
        parkScrollView.subviews[0].center = CGPoint(x: size.width/2.0, y: (size.height)/2.0)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
