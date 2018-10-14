//
//  OptionsViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/14/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

protocol OptionsDelegate {
    func userLocation(_ toggle : Bool)
    func showAllBuildings(_ toggle : Bool)
    func mapType(_ type : Int)
}

class OptionsViewController: UIViewController {

    var delegate : OptionsDelegate?
    var allBuildings = false
    var userLocation = false
    @IBOutlet var locationSwitch: UISwitch!
    @IBOutlet var allBuildingsSwitch: UISwitch!
    @IBOutlet var mapTypeControl: UISegmentedControl!
    
    @IBAction func enableLocation(_ sender: Any) {
        let toggle = locationSwitch.isOn
        dismiss(animated: true, completion: nil)
        delegate?.userLocation(toggle)
    }
    
    @IBAction func enableAllBuildings(_ sender: Any) {
        let toggle = allBuildingsSwitch.isOn
        dismiss(animated: true, completion: nil)
        delegate?.showAllBuildings(toggle)
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.mapType(mapTypeControl.selectedSegmentIndex)
    }
    
    @IBAction func cancelOptions(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapTypeControl.isSelected = false
        locationSwitch.isOn = userLocation
        allBuildingsSwitch.isOn = allBuildings
        // Do any additional setup after loading the view.
    }
    
    func configure(userLocation : Bool, allBuildings : Bool){
        self.allBuildings = allBuildings
        self.userLocation = userLocation
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
