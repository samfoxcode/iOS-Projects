//
//  ViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/22/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        print(numberOfParks)
        for i in 0..<numberOfParks {
            let view = UIScrollView(frame: CGRect.zero)
            let title = UILabel(frame: CGRect.zero)
            title.text = parkModel.park(i).name
            title.textAlignment = .center
            view.addSubview(title)
            parkPages.append(view)
            mainScrollView.addSubview(view)
        }
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
        
        // lay out all the pages on the scroll view
        for i in 0..<parkModel.lengthOfParks() {
            // set each page's fram
            let point = CGPoint(x: CGFloat(i)*size.width, y: 0)
            let frame = CGRect(origin: point, size: size)
            let page = parkPages[i]
            page.frame = frame
            // set title label's frame
            let label = page.subviews[0] // only subview
            let labelHeight : CGFloat = 20.0
            let labelWidth : CGFloat = page.bounds.width
            label.frame = CGRect(x: 0.0, y: CGFloat(30), width: labelWidth, height: labelHeight)
            
            for pictureIndex in 0..<parkModel.parkInfoLength(i) {
                print("\(parkModel.parkName(i))0\(pictureIndex)")
                let image = UIImage(named: "\(parkModel.parkName(i))0\(pictureIndex+1)")
                print(image)
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: CGFloat(i)*size.width, y: CGFloat(pictureIndex)*(image?.size.height)!+60.0, width: size.width, height: (image?.size.height)!)
                mainScrollView.addSubview(imageView)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

