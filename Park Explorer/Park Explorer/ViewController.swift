//
//  ViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/22/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    let parkModel = Model()
    let numberOfParks : Int
    var parkPages = [UIView]()
    var xOffset : CGFloat = 0.0
    var yOffset : CGFloat = 0.0
    var pictureLimit = [Int:Int]()
    var currentParkPage = 0
    var disabled = false
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        
        numberOfParks = parkModel.lengthOfParks()
        super.init(coder: aDecoder)
    }
    
    func configureScrollView() {
        mainScrollView.isPagingEnabled = true
        mainScrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        for i in 0..<numberOfParks {
            print(parkModel.park(i))
        }
    }

    override func viewDidLayoutSubviews() {
        let size = self.view.bounds.size
        mainScrollView.contentSize = CGSize(width: size.width * CGFloat(parkModel.lengthOfParks()), height: size.height*7)
        var offset : CGFloat = 0.0
        
        // Lay out all the pages on the scroll view.
        for i in 0..<parkModel.lengthOfParks() {

            // Set title label's frame.
            let label = UILabel(frame: CGRect.zero)
            let labelHeight : CGFloat = 20.0
            let labelWidth : CGFloat = size.width
            label.frame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(30), width: labelWidth, height: labelHeight)
            label.text = parkModel.park(i).name
            label.textAlignment = .center
            mainScrollView.addSubview(label)
            
            pictureLimit[i] = parkModel.parkInfoLength(i)
            
            for pictureIndex in 0..<parkModel.parkInfoLength(i) {
                print("\(parkModel.parkName(i))0\(pictureIndex)")
                let image = UIImage(named: "\(parkModel.parkName(i))0\(pictureIndex+1)")
                let imageView = UIImageView(image: image)
                
                if pictureIndex == 0 {
                    offset = 60.0
                }
                else {
                    offset = 0.0
                }
                
                
                let scrollFrame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(pictureIndex)*size.height+offset, width: size.width, height: size.height-offset)
                let imageScrollView = UIScrollView(frame: scrollFrame)
                imageScrollView.contentSize = CGSize(width: size.width, height: size.height)
                imageScrollView.delegate = self
                let imageHeightScale = size.width/(image?.size.width)!
                let imageViewSize = CGSize(width: (image?.size.width)!*imageHeightScale, height: (image?.size.height)!*imageHeightScale)
                imageView.frame.size = imageViewSize
                imageScrollView.minimumZoomScale = 1.0
                imageScrollView.maximumZoomScale = 10.0
                imageScrollView.tag = pictureIndex
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
        let imageCenter = CGPoint(x: scrollView.bounds.width/2.0,
                                  y: scrollView.bounds.height/2.0)
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
        print(currentParkPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(mainScrollView.contentOffset.y)
        print(self.view.bounds.height)
        print(pictureLimit[currentParkPage]!)
        if mainScrollView.contentOffset.y >= (CGFloat(pictureLimit[currentParkPage]!)*self.view.bounds.height){
            print("HIT")
            mainScrollView.contentOffset.y = yOffset
        }

        if mainScrollView.contentOffset.y > 0 && scrollView == mainScrollView {
            mainScrollView.showsHorizontalScrollIndicator = false
            mainScrollView.contentOffset.x = xOffset
        }
        else {
            mainScrollView.showsHorizontalScrollIndicator = true
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

