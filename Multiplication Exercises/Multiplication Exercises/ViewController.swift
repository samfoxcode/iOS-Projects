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
    
    var answerChoicesCollection = [0, 0, 0, 0]
    var internalMultiplicand = 0
    var internalMultiplier = 0
    var internalResult = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return answerChoicesCollection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(answerChoicesCollection[row])
    }

    func generateMultiplicationValues(){
        internalMultiplicand = Int(arc4random_uniform(15)+1)
        internalMultiplier = Int(arc4random_uniform(15)+1)
        multiplicand.text = String(internalMultiplicand)
        multiplier.text = String(internalMultiplier)
        internalResult = internalMultiplicand * internalMultiplier
        
        var randomResult = 0
        var valueToAdd = 0
        var internalResultCollection = [internalResult]
        
        while internalResultCollection.count <= 4 {
            randomResult = internalResult + Int(arc4random_uniform(5))+1
            if !(internalResultCollection.contains(randomResult)) {
                internalResultCollection.append(randomResult)
            }
        }
        var count = 0
        while answerChoicesCollection.contains(0) && count <= 4 {
            valueToAdd = internalResultCollection[Int(arc4random_uniform(4))]
            if !(answerChoicesCollection.contains(valueToAdd)){
                answerChoicesCollection[count] = valueToAdd
                count = count + 1
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMultiplicationValues()
        submitNextButton.setTitle("Submit", for: UIControlState.normal)
        answerChoices.delegate = self
        answerChoices.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitAndNextButton(_ sender: Any) {
        let selectedChoice = answerChoices.selectedRow(inComponent: 1)
        
        
        
    }
    
}

