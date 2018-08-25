//
//  ViewController.swift
//  Multiplication Exercises
//
//  Created by Samuel Fox on 8/25/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var multiplicand: UILabel!
    @IBOutlet var multiplier: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var answerChoices: UIPickerView!
    @IBOutlet var questionsStatus: UILabel!
    @IBOutlet var submitNextButton: UIButton!
    @IBOutlet var correctLabel: UILabel!
    
    let defaultAnswerChoices = [0, 0, 0, 0]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return defaultAnswerChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(defaultAnswerChoices[row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitNextButton.setTitle("Submit", for: UIControlState.normal)
        answerChoices.delegate = self
        answerChoices.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitAndNextButton(_ sender: Any) {
        
    }
    
}

