//
//  ParkImageViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/7/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var parkScrollView: UIScrollView!
    
    var parkImage : UIImage?
    var parkName : String?
    var caption : String?
    
    let kMaximumScale : CGFloat = 10.0
    let kMinimumScale : CGFloat = 1.0
    let kZoomScale : CGFloat = 1.001
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if parkImage == nil {
            return
        }
        
        let imageView = UIImageView(image: parkImage)
        let imageWidthScale = self.view.frame.width/(self.parkImage?.size.width)!
        let imageHeightScale = self.view.frame.height/(self.parkImage?.size.height)!
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        
        imageView.frame.size = CGSize(width: (self.parkImage?.size.width)!*imageScale, height: (self.parkImage?.size.height)!*imageScale)
        imageView.center = CGPoint(x: self.view.bounds.width/2.0, y: (self.view.bounds.height)/2.0)
        parkScrollView!.frame = CGRect(origin: self.view.bounds.origin, size: self.view.frame.size)
        parkScrollView!.minimumZoomScale = kMinimumScale
        parkScrollView!.maximumZoomScale = kMaximumScale
        parkScrollView!.addSubview(imageView)
        parkScrollView!.delegate = self
        
        self.view.addSubview(self.parkScrollView!)
        self.view.bringSubviewToFront(parkScrollView!)
        
        self.parkScrollView!.zoomScale = kZoomScale
    }
    
    func configure(_ image: UIImage, _ assignCaption : String, _ assignParkName : String) {
        parkImage = image
        parkName = assignParkName
        caption = assignCaption
    }
    
    // Image centering from class.
    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        var imageCenter = CGPoint(x: scrollView.contentSize.width/2.0, y: scrollView.contentSize.height/2.0)
        
        if scrollView.contentSize.width <= scrollView.frame.size.width {
            imageCenter.x = scrollView.frame.width/2.0
        }
        
        if scrollView.contentSize.height <= scrollView.frame.size.height {
            imageCenter.y = scrollView.frame.height/2.0
        }
        
        
        return imageCenter
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count > 0 {
            return scrollView.subviews[0]
        }
        return nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.subviews[0].center = centerForImage(scrollView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollViewTransitionUpdate(size, self.view)
    }
    
    func scrollViewTransitionUpdate(_ size : CGSize, _ mainView : UIView) {
        if parkImage == nil {
            return
        }
        let imageWidthScale = size.width/(parkImage!.size.width)
        let imageHeightScale = size.height/(parkImage!.size.height)
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        let imageViewSize = CGSize(width: (parkImage!.size.width)*imageScale, height: (parkImage!.size.height)*imageScale)
        parkScrollView!.zoomScale = kZoomScale
        parkScrollView!.subviews[0].frame.size = imageViewSize
        parkScrollView!.contentSize = size
        parkScrollView!.frame.size = size
        parkScrollView!.subviews[0].center = CGPoint(x: size.width/2.0, y: parkScrollView!.frame.size.height/2.0)
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
