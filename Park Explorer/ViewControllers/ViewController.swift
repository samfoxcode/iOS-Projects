//
//  ViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/22/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    let parkModel = Model.sharedInstance
    let numberOfParks : Int
    let kFirstPictureOffset : CGFloat = 60.0
    let kParkTitleHeight : CGFloat = 20.0
    let kParkTitleVerticalHeight : CGFloat = 30.0
    let kMinZoomScale : CGFloat = 1.0
    let kMaxZoomScale : CGFloat = 10.0
    var parkPages = [UIView]()
    var xOffset : CGFloat = 0.0
    var yOffset : CGFloat = 0.0
    var pictureLimit = [Int:Int]()
    var currentParkPage = 0
    var disabled = false
    var leftArrowVisible = false
    var rightArrowVisible = true
    var upArrowVisible = false
    var downArrowVisible = true
    
    @IBOutlet var leftArrow: UIImageView!
    @IBOutlet var rightArrow: UIImageView!
    @IBOutlet var upArrow: UIImageView!
    @IBOutlet var downArrow: UIImageView!
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        
        numberOfParks = parkModel.lengthOfParks()
        super.init(coder: aDecoder)
    }
    
    func configureMainScrollView() {
        mainScrollView.isPagingEnabled = true
        mainScrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainScrollView()
    }

    override func viewDidLayoutSubviews() {
        let size = self.view.bounds.size
        mainScrollView.contentSize = CGSize(width: size.width * CGFloat(parkModel.lengthOfParks()), height: size.height*7)
        var offset : CGFloat = 0.0
        
        // Lay out all the pages on the scroll view.
        for i in 0..<parkModel.lengthOfParks() {

            // Set title label's frame.
            let label = UILabel(frame: CGRect.zero)
            let labelHeight : CGFloat = kParkTitleHeight
            let labelWidth : CGFloat = size.width
            label.frame = CGRect(x: CGFloat(i)*size.width, y: kParkTitleVerticalHeight, width: labelWidth, height: labelHeight)
            let parkName = parkModel.park(i)
            label.text = parkName
            label.textAlignment = .center
            mainScrollView.addSubview(label)
            
            pictureLimit[i] = parkModel.parkInfoLength(i)
            
            for pictureIndex in 0..<parkModel.parkInfoLength(i) {
                
                let parkName = "\(parkName)0\(pictureIndex+1)"
                let image = UIImage(named: parkName)
                let imageView = UIImageView(image: image)
                
                if pictureIndex == 0 {
                    offset = kFirstPictureOffset
                }
                else {
                    offset = 0.0
                }
                
                let scrollFrame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(pictureIndex)*size.height+offset, width: size.width, height: size.height-offset)
                let imageScrollView = UIScrollView(frame: scrollFrame)
                imageScrollView.contentSize = CGSize(width: size.width, height: size.height-offset)
                imageScrollView.delegate = self
                
                let imageHeightScale = size.width/(image?.size.width)!
                let imageViewSize = CGSize(width: (image?.size.width)!*imageHeightScale, height: (image?.size.height)!*imageHeightScale)
                imageView.frame.size = imageViewSize
                
                imageScrollView.minimumZoomScale = kMinZoomScale
                imageScrollView.maximumZoomScale = kMaxZoomScale
                imageScrollView.zoomScale = imageHeightScale
                
                imageScrollView.addSubview(imageView)
                imageView.center = CGPoint(x: imageScrollView.contentSize.width/2.0, y: (imageScrollView.contentSize.height-offset)/2.0)
                
                mainScrollView.addSubview(imageScrollView)
            }
            
        }
    }
    
    func scaleFor(size:CGSize) -> CGFloat {
        let viewSize = self.view.bounds.size
        let widthScale = viewSize.width/size.width
        let heightScale = viewSize.height/size.height
        return min(widthScale,heightScale)
    }

    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        // Center the image.
        let imageCenter = CGPoint(x: scrollView.bounds.width/2.0, y: scrollView.bounds.height/2.0)
        return imageCenter
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != mainScrollView && scrollView.subviews.count > 0 {
            return scrollView.subviews[0]
        }
        return nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Save the offset of the current page before it changes, then set it in scrollViewDidScroll
        xOffset = mainScrollView.contentOffset.x
        yOffset = mainScrollView.contentOffset.y
        currentParkPage = Int(xOffset/self.view.bounds.width)

        if scrollView == mainScrollView {
            if leftArrowVisible && currentParkPage > 0 && yOffset/self.view.bounds.height <= 1 {
                leftArrow.isHidden = false
            }
            if downArrowVisible {
                downArrow.isHidden = false
            }
            if rightArrowVisible && yOffset/self.view.bounds.height <= 1 {
                rightArrow.isHidden = false
            }
            if upArrowVisible && yOffset/self.view.bounds.height >= 1 {
                upArrow.isHidden = false
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == mainScrollView {
            rightArrow.isHidden = true
            leftArrow.isHidden = true
            upArrow.isHidden = true
            downArrow.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainScrollView.contentOffset.y >= (CGFloat(pictureLimit[currentParkPage]!)*self.view.bounds.height){
            mainScrollView.contentOffset.y = yOffset
            downArrowVisible = false
        }
        else {
            downArrowVisible = true
        }

        if mainScrollView.contentOffset.y > 0 && scrollView == mainScrollView {
            mainScrollView.showsHorizontalScrollIndicator = false
            mainScrollView.contentOffset.x = xOffset
            
            leftArrowVisible = false
            rightArrowVisible = false
            upArrowVisible = true
        }
        else {
            mainScrollView.showsHorizontalScrollIndicator = true
            leftArrowVisible = true
            rightArrowVisible = true
            upArrowVisible = false
        }
        
    }
 
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Update imageView center and if user is currently zoomed in on an image, disabling scrolling on mainScrollView
        if scrollView != mainScrollView && scrollView.subviews.count > 0 {
            if scrollView.zoomScale != 1.0 {
                disabled = true
                mainScrollView.isScrollEnabled = false
            }
            else {
                disabled = false
                mainScrollView.isScrollEnabled = true
            }
            scrollView.subviews[0].center = centerForImage(scrollView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

