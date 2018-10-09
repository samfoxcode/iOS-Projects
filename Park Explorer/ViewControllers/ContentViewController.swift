//
//  ContentViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/7/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var demoImageView: UIImageView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    var demoImage : UIImage?
    var pageIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFrameUpdate(self.view.frame.size, self.view)
        demoImageView.image = demoImage
    }
    
    func configure(_ image : UIImage) {
        demoImage = image
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewFrameUpdate(size, self.view)
    }
    
    func viewFrameUpdate(_ size : CGSize, _ mainView : UIView) {
        if demoImageView.image == nil {
            return
        }
        let imageWidthScale = size.width/(demoImage!.size.width)
        let imageHeightScale = size.height/(demoImage!.size.height)
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        let imageViewSize = CGSize(width: (demoImage!.size.width), height: (demoImage!.size.height)*imageScale)
        demoImageView.frame.size = imageViewSize
    }
    
}
