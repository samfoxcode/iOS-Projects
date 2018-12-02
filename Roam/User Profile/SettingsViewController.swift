//
//  SettingsViewController.swift
//  Roam
//
//  Created by Samuel Fox on 12/2/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var clearCacheButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearCacheButton.layer.cornerRadius = 4.0
    }
    
    @IBAction func clearCacheAction(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        
        let fileManager = FileManager()
        
        let directoryPath = NSHomeDirectory().appending("/Library/Caches/")
        if fileManager.fileExists(atPath: directoryPath) {
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: directoryPath)
                for filePath in filePaths {
                    if filePath.hasSuffix(".jpg"){
                        print(filePath)
                        try fileManager.removeItem(atPath: directoryPath + filePath)
                    }
                }
                let alertView = UIAlertController(title: "All Clear", message: "Successfully cleared cache", preferredStyle: .alert)
                let clearedCache = UIAlertAction(title: "OK", style: .cancel)
                alertView.addAction(clearedCache)
                self.present(alertView, animated: true, completion: nil)
                
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
            }
            catch{
                let alertView = UIAlertController(title: "Uh Oh", message: "\(error)", preferredStyle: .alert)
                let clearedCache = UIAlertAction(title: "OK", style: .cancel)
                alertView.addAction(clearedCache)
                self.present(alertView, animated: true, completion: nil)
                
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
            }
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

}
