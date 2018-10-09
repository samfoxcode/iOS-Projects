//
//  ParkImageViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/7/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkImageViewController: UIViewController {

    //@IBOutlet var parkScrollView: UIScrollView!
    
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var parkImageView: UIImageView!
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
        
        self.title = parkName
        captionLabel.text = caption
        parkImageView.image = parkImage
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
