//
//  ScrollViewManager.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/1/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import Foundation
import UIKit

class ScrollViewManager: UIScrollView, UIScrollViewDelegate {
    
    var parkImageGlobal : UIImage?
    var parkScrollViewGlobal : UIScrollView?
    
    func populateScrollView(_ indexPath : IndexPath, _ parkModel : Model, _ mainView : UIView) {
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        parkImageGlobal = UIImage(named: parkImageName)
        parkScrollViewGlobal = UIScrollView(frame: mainView.frame)
        parkScrollViewGlobal!.backgroundColor = UIColor.darkGray
        let imageView = UIImageView(image: parkImageGlobal)
        let imageHeightScale = mainView.bounds.width/(parkImageGlobal?.size.width)!
        let imageViewSize = CGSize(width: (parkImageGlobal?.size.width)!*imageHeightScale, height: (parkImageGlobal?.size.height)!*imageHeightScale)
        imageView.frame.size = imageViewSize
        parkScrollViewGlobal!.minimumZoomScale = 1.0
        parkScrollViewGlobal!.maximumZoomScale = 10.0
        parkScrollViewGlobal!.zoomScale = imageHeightScale
        parkScrollViewGlobal!.contentSize = mainView.bounds.size
        imageView.center = CGPoint(x: mainView.bounds.width/2.0, y: (mainView.bounds.height)/2.0)
        parkScrollViewGlobal!.addSubview(imageView)
        parkScrollViewGlobal!.delegate = self
        mainView.addSubview(parkScrollViewGlobal!)
        mainView.bringSubviewToFront(parkScrollViewGlobal!)
    }
    
    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        // Center the image.
        let imageCenter = CGPoint(x: scrollView.contentSize.width/2.0, y: scrollView.frame.size.height/2.0)
        return imageCenter
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count > 0 {
            print(scrollView.subviews)
            return scrollView.subviews[0]
        }
        return nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.subviews[0].center = centerForImage(scrollView)
        if scrollView.zoomScale == 1.0 {
            scrollView.subviews[0].removeFromSuperview()
            scrollView.removeFromSuperview()
        }
    }
    
    
    
}
