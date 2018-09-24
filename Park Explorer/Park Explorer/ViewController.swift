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
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        
        numberOfParks = parkModel.lengthOfParks()
        super.init(coder: aDecoder)
    }
    
    func configureScrollView() {
        mainScrollView.isPagingEnabled = true
        /*
        print(numberOfParks)
        for i in 0..<numberOfParks {
            let view = UIScrollView(frame: CGRect.zero)
            let title = UILabel(frame: CGRect.zero)
            //view.minimumZoomScale = 0.1
            //view.maximumZoomScale = 10
            //view.delegate = self
            title.text = parkModel.park(i).name
            title.textAlignment = .center
            view.addSubview(title)
            parkPages.append(view)
            mainScrollView.addSubview(view)
        }
        */
 
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
        // lay out all the pages on the scroll view
        for i in 0..<parkModel.lengthOfParks() {
            // set each page's fram
            let point = CGPoint(x: CGFloat(i)*size.width, y: 0)

            // set title label's frame
            
            let label = UILabel(frame: CGRect.zero)//page.subviews[0] // only subview
            let labelHeight : CGFloat = 20.0
            let labelWidth : CGFloat = size.width
            label.frame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(30), width: labelWidth, height: labelHeight)
            label.text = parkModel.park(i).name
            label.textAlignment = .center
            mainScrollView.addSubview(label)
            
            for pictureIndex in 0..<parkModel.parkInfoLength(i) {
                print("\(parkModel.parkName(i))0\(pictureIndex)")
                let image = UIImage(named: "\(parkModel.parkName(i))0\(pictureIndex+1)")
                //print(image)
                let imageView = UIImageView(image: image)
                
                if pictureIndex == 0 {
                    offset = 60.0
                }
                else {
                    offset = 0.0
                }
                
                let scrollFrame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(pictureIndex)*size.height+offset, width: size.width, height: size.height)
                let imageScrollView = UIScrollView(frame: scrollFrame)
                imageScrollView.contentSize = CGSize(width: size.width, height: size.height)
                imageScrollView.delegate = self
                //imageView.center = imageScrollView.center
                
                let imageHeightScale = size.width/(image?.size.width)!
                //print(imageHeightScale)
                let imageViewFrame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(pictureIndex)*size.height+offset, width: size.width, height: (image?.size.height)!*imageHeightScale)
                //imageView.frame = imageViewFrame
                //imageView.center.x = imageScrollView.center.x
                //imageView.center.y = imageScrollView.center.y - offset
                
                //print(imageScrollView.subviews)
                //print(imageScrollView)
                imageScrollView.addSubview(imageView)
                imageView.center = CGPoint(x: imageScrollView.contentSize.width/2.0, y: imageScrollView.contentSize.height/2.0)
                mainScrollView.addSubview(imageScrollView)
                //print(imageScrollView.subviews)
            }
            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print(scrollView.subviews[2])
        if scrollView != mainScrollView {
        return scrollView.subviews[2]
        }
        return nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // need to update position of image whenever zooming occurs
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

