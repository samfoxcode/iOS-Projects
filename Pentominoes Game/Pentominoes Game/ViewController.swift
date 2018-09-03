//
//  ViewController.swift
//  Pentominoes Game
//
//  Created by Samuel Fox on 9/3/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mainBoardView: UIImageView!
    
    @IBAction func changeBoard(sender: UIButton) {
        switch sender.tag{
            case 0:
                mainBoardView.image = #imageLiteral(resourceName: "Board0")
            case 1:
                mainBoardView.image = #imageLiteral(resourceName: "Board1")
            case 2:
                mainBoardView.image = #imageLiteral(resourceName: "Board2")
            case 3:
                mainBoardView.image = #imageLiteral(resourceName: "Board3")
            case 4:
                mainBoardView.image = #imageLiteral(resourceName: "Board4")
            case 5:
                mainBoardView.image = #imageLiteral(resourceName: "Board5")
            default:
                return
        }
    }
    
    @IBAction func solve(_ sender: Any) {
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

