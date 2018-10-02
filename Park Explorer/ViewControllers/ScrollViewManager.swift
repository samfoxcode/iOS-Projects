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
    var _frame = CGRect.zero
    var _center = CGPoint.zero
    var imageViewDisappear : UIImageView?
    
    func populateScrollView(_ indexPath : IndexPath, _ parkModel : Model, _ mainView : UIView, _ view : Any?, _ tableOrCollection : Any? ) {
        

        if let table = tableOrCollection as? ParkTableViewCell {
            self.tableViewCell = table
            _frame = CGRect(origin: (tableViewCell?.parkImageView.bounds.origin)!, size: (tableViewCell?.parkImageView.frame.size)!)
            _center = (tableViewCell?.parkImageView.center)!
        }
        if let collection = tableOrCollection as? ParkCollectionViewCell {
            self.collectionViewCell = collection
            _frame = CGRect(origin: (collectionViewCell?.parkImageView.bounds.origin)!, size: (collectionViewCell?.parkImageView.frame.size)!)
            _center = (collectionViewCell?.parkImageView.center)!
        }
        print(_center)
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        parkImageGlobal = UIImage(named: parkImageName)
        parkScrollViewGlobal = UIScrollView(frame: _frame)
        let imageView = UIImageView(image: parkImageGlobal)
        imageViewDisappear = imageView
        imageView.frame.size = _frame.size
        let updateCenter = CGPoint(x: _center.x*CGFloat(indexPath[1]+indexPath[0]), y: center.y*(CGFloat(indexPath[0])+1.0))
        imageView.center = updateCenter
        parkScrollViewGlobal!.center = updateCenter
        print(imageView.center)
        parkScrollViewGlobal!.minimumZoomScale = 1.0
        parkScrollViewGlobal!.maximumZoomScale = 10.0
        parkScrollViewGlobal!.addSubview(imageView)
        parkScrollViewGlobal!.delegate = self
        mainView.addSubview(self.parkScrollViewGlobal!)
        mainView.bringSubviewToFront(parkScrollViewGlobal!)
        let imageWidthScale = mainView.frame.width/(self.parkImageGlobal?.size.width)!
        let imageHeightScale = mainView.frame.height/(self.parkImageGlobal?.size.height)!
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let imageViewSize = CGSize(width: (self.parkImageGlobal?.size.width)!*imageScale, height: (self.parkImageGlobal?.size.height)!*imageScale)
            imageView.frame.size = imageViewSize
            self.parkScrollViewGlobal!.contentSize = mainView.bounds.size
            imageView.center = CGPoint(x: mainView.bounds.width/2.0, y: (mainView.bounds.height)/2.0)
            self.parkScrollViewGlobal!.frame = CGRect(origin: mainView.bounds.origin, size: mainView.frame.size)
        })
        self.parkScrollViewGlobal!.zoomScale = 1.0
        //self.parkScrollViewGlobal!.backgroundColor = UIColor.darkGray
        
        if let checkView = view as? UITableView {
            self.tableView = checkView
        }
        if let checkView = view as? UICollectionView {
            self.collectionView = checkView
        }
        
    }
    
    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        // Center the image.
        let imageCenter = CGPoint(x: scrollView.contentSize.width/2.0, y: scrollView.frame.size.height/2.0)
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
        if scrollView.zoomScale <= 1.0 && !scrollView.isDragging && !scrollView.isZooming{
            //scrollView.subviews[0].removeFromSuperview()
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.imageViewDisappear!.frame = self._frame
                self.imageViewDisappear!.center = self._center
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
    }
    
    func scrollViewTransitionUpdate(_ size : CGSize) {
        let imageWidthScale = size.width/(parkImageGlobal!.size.width)
        let imageHeightScale = size.height/(parkImageGlobal!.size.height)
        let imageScale = imageWidthScale < imageHeightScale ? imageWidthScale : imageHeightScale
        
        let imageViewSize = CGSize(width: (parkImageGlobal!.size.width)*imageScale, height: (parkImageGlobal!.size.height)*imageScale)
        parkScrollViewGlobal!.subviews[0].frame.size = imageViewSize
        parkScrollViewGlobal!.zoomScale = 1.0
        parkScrollViewGlobal!.contentSize = size
        parkScrollViewGlobal!.frame.size = size
        parkScrollViewGlobal!.subviews[0].center = CGPoint(x: size.width/2.0, y: (size.height)/2.0)
    }
    
    
}
