//
//  MainTabBarViewController.swift
//  Roam
//
//  Created by Samuel Fox on 12/2/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    @objc func onNotification(notification:Notification) {
        if notification.name == Notification.Name("settingsChanged") {
            if notification.userInfo!["theme"] as! String == Themes.Dark.rawValue {
                print("DARK THEME")
                self.tabBar.barTintColor = UIColor.darkGray
                self.tabBar.tintColor = UIColor.white
            }
            else {
                print("LIGHT THEME")
                self.tabBar.barTintColor = UIColor.white
                self.tabBar.tintColor = self.view.tintColor
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: SettingsViewController.settingsChanged, object: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
