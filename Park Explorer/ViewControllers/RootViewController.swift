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
    
    @IBOutlet var endDemoButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
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
        self.view.bringSubviewToFront(pageControl)
        
    }

    //MARK: - UIPageViewController Data Source
    func contentController(at index:Int) -> ContentViewController {
        let content = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        
        let image = UIImage(named: "Demo\(index+1)")

        content.pageIndex = index
        
        content.configure(image!)
        
        return content
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        let pageEnded = pageViewController.viewControllers![0] as! ContentViewController
        
        pageControl.currentPage = pageEnded.pageIndex!
        self.view.bringSubviewToFront(pageControl)
        if pageEnded.pageIndex == 2 {
            self.view.bringSubviewToFront(endDemoButton)
            endDemoButton.isHidden = false
        }
        else {
            endDemoButton.isHidden = true
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
    
}
