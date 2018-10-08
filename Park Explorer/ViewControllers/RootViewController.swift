//
//  RootViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/7/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.


//  Code is derived from 475's class RootViewController

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController?
    let parkModel = Model.sharedInstance
    
    var currentPageIndex = 0
    
    @IBOutlet var endDemoButton: UIButton!
    
    @IBAction func endDemo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        let firstPage =  contentController(at: 0)
        pageViewController!.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        
        // need these so that pageViewController delegate is told about orientation changes
        self.addChild(pageViewController!)
        pageViewController?.didMove(toParent: self)
        
        self.view.addSubview(pageViewController!.view)
        
    }

    //MARK: - UIPageViewController Data Source
    func contentController(at index:Int) -> ContentViewController {
        let content = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        
        let image = UIImage(named: "Demo\(index+1)")

        content.pageIndex = index
        
        content.configure(image!)
        
        /*self.view.bringSubviewToFront(endDemoButton)
        endDemoButton.isHidden = true
        if content.pageIndex == 2 {
            endDemoButton.isHidden = false
        }
        */
        return content
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        currentPageIndex = currentPageIndex + 1
        print(currentPageIndex)
        if currentPageIndex >= 2 {
            self.view.bringSubviewToFront(endDemoButton)
            endDemoButton.isHidden = false
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        let index = contentViewController.pageIndex!
        
        guard index < 2 else {return nil}
        
        let newController =  contentController(at: index+1)
        return newController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let contentViewController = viewController as! ContentViewController
        let index = contentViewController.pageIndex!
        
        guard index > 0 else {return nil}
        
        let newController =  contentController(at: index-1)
 
        return newController
    }
    
    
    // MARK: - UIPageViewController delegate methods
    
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
            
            self.pageViewController!.isDoubleSided = false
            return .min
        }
        
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! ContentViewController
        var viewControllers: [UIViewController]
        
        let indexOfCurrentViewController = currentViewController.pageIndex!
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        
        return .mid
    }
    
}
