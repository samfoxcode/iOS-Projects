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
    var tableView : UITableView?
    var collectionView : UICollectionView?
    
    var tableViewCell : ParkTableViewCell?
    var collectionViewCell : ParkCollectionViewCell?
    var internalFrame = CGRect.zero
    var internalCenter = CGPoint.zero
    var imageViewDisappear : UIImageView?
    
    let kMaximumScale : CGFloat = 10.0
    let kMinimumScale : CGFloat = 1.0
    let kZoomScale : CGFloat = 1.001
    
    // Populate scrollview and initialize frame to be the imageView in the selected cell.
    func populateScrollView(_ indexPath : IndexPath, _ parkModel : Model, _ mainView : UIView, _ view : Any?, _ tableOrCollection : Any? ) {
        
        if let table = tableOrCollection as? ParkTableViewCell {
            self.tableViewCell = table
            internalFrame = CGRect(origin: (tableViewCell?.parkImageView.bounds.origin)!, size: (tableViewCell?.parkImageView.frame.size)!)
            internalCenter = (tableViewCell?.parkImageView.center)!
        }
        if let collection = tableOrCollection as? ParkCollectionViewCell {
            self.collectionViewCell = collection
            internalFrame = CGRect(origin: (collectionViewCell?.parkImageView.bounds.origin)!, size: (collectionViewCell?.parkImageView.frame.size)!)
            internalCenter = (collectionViewCell?.parkImageView.center)!
        }
        
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        parkImageGlobal = UIImage(named: parkImageName)
        parkScrollViewGlobal = UIScrollView(frame: internalFrame)
        let imageView = UIImageView(image: parkImageGlobal)
        imageView.frame.size = internalFrame.size
        let updateCenter = CGPoint(x: internalCenter.x*CGFloat(indexPath[1]+indexPath[0]), y: center.y*(CGFloat(indexPath[0])+1.0))
        imageView.center = updateCenter
        parkScrollViewGlobal!.center = updateCenter
        parkScrollViewGlobal!.minimumZoomScale = kMinimumScale
        parkScrollViewGlobal!.maximumZoomScale = kMaximumScale
        parkScrollViewGlobal!.addSubview(imageView)
        parkScrollViewGlobal!.delegate = self
        
        mainView.addSubview(self.parkScrollViewGlobal!)
        mainView.bringSubviewToFront(parkScrollViewGlobal!)
        
        let imageWidthScale = mainView.frame.width/(self.parkImageGlobal?.size.width)!
        let imageHeightScale = mainView.frame.height/(self.parkImageGlobal?.size.height)!
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        self.parkScrollViewGlobal!.zoomScale = kZoomScale
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let imageViewSize = CGSize(width: (self.parkImageGlobal?.size.width)!*imageScale, height: (self.parkImageGlobal?.size.height)!*imageScale)
            imageView.frame.size = imageViewSize
            self.parkScrollViewGlobal!.contentSize = mainView.bounds.size
            imageView.center = CGPoint(x: mainView.bounds.width/2.0, y: (mainView.bounds.height)/2.0)
            self.parkScrollViewGlobal!.frame = CGRect(origin: mainView.bounds.origin, size: mainView.frame.size)
            //self.parkScrollViewGlobal!.center = CGPoint(x: mainView.bounds.width/2, y: mainView.bounds.origin.y+mainView.frame.height)
        }, completion: {(finished) in
            print(self.parkScrollViewGlobal?.center)
            print(imageView.center)
            print(mainView.bounds)
            self.imageViewDisappear = imageView
        })
        
        if let checkView = view as? UITableView {
            self.tableView = checkView
        }
        if let checkView = view as? UICollectionView {
            self.collectionView = checkView
        }
        
    }
    
    // Image centering from class.
    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        var imageCenter = CGPoint(x: scrollView.contentSize.width/2.0,
                                  y: scrollView.contentSize.height/2)
        
        
        let scrollViewSize = scrollView.bounds.size
        let scrollViewCenter = scrollView.center
        
        if (scrollView.contentSize.width < scrollViewSize.width) {
            imageCenter.x = scrollViewCenter.x;
        }
        
        if (scrollView.contentSize.height < scrollViewSize.height) {
            imageCenter.y = scrollViewCenter.y;
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
        if scrollView.zoomScale <= 1.0 && !scrollView.isDragging && !scrollView.isZooming {
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.imageViewDisappear!.frame = self.internalFrame
                self.imageViewDisappear!.center = self.internalCenter
            }, completion: {(finished) in
                
                if let enableTableView = self.tableView {
                    enableTableView.isScrollEnabled = true
                }
                if let enableCollectView = self.collectionView {
                    enableCollectView.isScrollEnabled = true
                }
                scrollView.removeFromSuperview()
                
            })
            
        }
        scrollView.subviews[0].center = centerForImage(scrollView)
    }
    
    func scrollViewTransitionUpdate(_ size : CGSize) {
        let imageWidthScale = size.width/(parkImageGlobal!.size.width)
        let imageHeightScale = size.height/(parkImageGlobal!.size.height)
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        let imageViewSize = CGSize(width: (parkImageGlobal!.size.width)*imageScale, height: (parkImageGlobal!.size.height)*imageScale)
        parkScrollViewGlobal!.zoomScale = kZoomScale
        parkScrollViewGlobal!.subviews[0].frame.size = imageViewSize
        imageViewDisappear = (parkScrollViewGlobal!.subviews[0] as! UIImageView)
        parkScrollViewGlobal!.contentSize = size
        parkScrollViewGlobal!.frame.size = size
        parkScrollViewGlobal!.subviews[0].center = CGPoint(x: size.width/2.0, y: (size.height)/2.0)
        //self.parkScrollViewGlobal!.center = CGPoint(x: size.width/2.0, y: (size.height)/2.0)
    }
    
    
}
