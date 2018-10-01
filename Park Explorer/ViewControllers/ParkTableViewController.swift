//
//  ParkTableViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/28/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController {

    @IBOutlet var parkTableView: UITableView!
    
    let parkModel = Model()
    let scrollViewManager = ScrollViewManager()
    var collapse = false
    var collapseSection = 0
    var collapsedSections = [Int]()
    //var parkScrollViewGlobal : UIScrollView?
    //var parkImageGlobal : UIImage?
    
    @IBAction func collapseSectionAction(_ sender: UIButton) {
        if collapsedSections.contains(sender.tag){
            collapsedSections.remove(at: collapsedSections.firstIndex(of: sender.tag)!)
        }
        else {
            collapsedSections.append(sender.tag)
        }
        parkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.lengthOfParks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if collapsedSections.contains(section) {
            return 0
        }
        else {
            return parkModel.parkInfoLength(section)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkHeaderCell") as! HeaderTableViewCell
        cell.headerButton.setTitle(parkModel.park(section), for: .normal)
        cell.headerButton.tag = section
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParkTableViewCell
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        let parkImage = UIImage(named: parkImageName)
        cell.parkImageView.image = parkImage
        cell.captionTextView.text = parkModel.parkCaption(indexPath.section, indexPath.row, parkImageName)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        scrollViewManager.populateScrollView(indexPath, parkModel, self.view)
        
        /*
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        parkImageGlobal = UIImage(named: parkImageName)
        parkScrollViewGlobal = UIScrollView(frame: self.view.frame)
        parkScrollViewGlobal!.backgroundColor = UIColor.darkGray
        let imageView = UIImageView(image: parkImageGlobal)
        let imageHeightScale = self.view.bounds.width/(parkImageGlobal?.size.width)!
        let imageViewSize = CGSize(width: (parkImageGlobal?.size.width)!*imageHeightScale, height: (parkImageGlobal?.size.height)!*imageHeightScale)
        imageView.frame.size = imageViewSize
        parkScrollViewGlobal!.minimumZoomScale = 1.0
        parkScrollViewGlobal!.maximumZoomScale = 10.0
        parkScrollViewGlobal!.zoomScale = imageHeightScale
        parkScrollViewGlobal!.contentSize = self.view.bounds.size
        imageView.center = CGPoint(x: self.view.bounds.width/2.0, y: (self.view.bounds.height)/2.0)
        parkScrollViewGlobal!.addSubview(imageView)
        parkScrollViewGlobal!.delegate = self
        self.view.addSubview(parkScrollViewGlobal!)
        self.view.bringSubviewToFront(parkScrollViewGlobal!)
        */
    }
    
    /*
    func centerForImage(_ scrollView : UIScrollView) -> CGPoint {
        // Center the image.
        let imageCenter = CGPoint(x: scrollView.contentSize.width/2.0, y: scrollView.frame.size.height/2.0)
        return imageCenter
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count > 0 {
            print(scrollView.subviews)
            return scrollView.subviews[0]
        }
        return nil
    }
    
    override func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.subviews[0].center = centerForImage(scrollView)
        if scrollView.zoomScale == 1.0 {
            scrollView.subviews[0].removeFromSuperview()
            scrollView.removeFromSuperview()
            self.view.bringSubviewToFront(parkTableView)
        }
    }
 
    */
    
 
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (scrollViewManager.parkImageGlobal != nil) {
            //let imageHeightScale = size.width/(image.size.width)
            //let imageViewSize = CGSize(width: (image.size.width)*imageHeightScale, height: (image.size.height)*imageHeightScale)
            //scrollViewManager.parkScrollViewGlobal!.subviews[0].frame.size = imageViewSize
            //scrollViewManager.parkScrollViewGlobal!.zoomScale = imageHeightScale
            scrollViewManager.parkScrollViewGlobal!.contentSize = size
            scrollViewManager.parkScrollViewGlobal!.frame.size = size
            scrollViewManager.parkScrollViewGlobal!.subviews[0].center = CGPoint(x: size.width/2.0, y: (size.height)/2.0)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
