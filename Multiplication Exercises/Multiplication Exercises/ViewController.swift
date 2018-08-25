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
    var attempts = 0
    var totalCorrect = 0
    
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
        
        // Populate a collection of random results as well as the correct one for internal use
        while internalResultCollection.count <= 4 {
            randomResult = internalResult + Int(arc4random_uniform(5))+1
            if !(internalResultCollection.contains(randomResult)) {
                internalResultCollection.append(randomResult)
            }
        }
        
        // Now populate the picker collection with the other result values, but in a random order
        var count = 0
        while answerChoicesCollection.contains(0) && count <= 4{
            valueToAdd = internalResultCollection[Int(arc4random_uniform(4))]
            if !(answerChoicesCollection.contains(valueToAdd)){
                answerChoicesCollection[count] = valueToAdd
                count = count + 1
            }
        }
        
    }
    
    func startAndRestartGame(){
        answerChoicesCollection = [0, 0, 0, 0]
        internalMultiplicand = 0
        internalMultiplier = 0
        internalResult = 0
        attempts = 0
        totalCorrect = 0
        questionsStatus.text = "0/0 Questions Correct"
        result.text = String("")
        generateMultiplicationValues()
        correctLabel.textColor = UIColor.black
        correctLabel.text = "You are..."
        submitNextButton.setTitle("Submit", for: UIControlState.normal)
        answerChoices.delegate = self
        answerChoices.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAndRestartGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitAndNextButton(_ sender: Any) {
        
        if submitNextButton.currentTitle == "Submit" {
            
            let selectedChoice = answerChoices.selectedRow(inComponent: 0)
            result.text = String(internalResult)
            
            if answerChoicesCollection[selectedChoice] != internalResult {
                correctLabel.textColor = UIColor.red
                correctLabel.text = "Wrong!"
                attempts = attempts + 1
            }
            else {
                correctLabel.textColor = UIColor.green
                correctLabel.text = "Correct!"
                attempts = attempts + 1
                totalCorrect = totalCorrect + 1
            }
            
            questionsStatus.text = String(totalCorrect) + "/" + String(attempts) + " Questions Correct"
            
            if totalCorrect == 5 {
                let alert = UIAlertController(title: "Congrats!", message: "You answered correctly 5 times, hit OK to restart!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                startAndRestartGame()
            }
            else {
                submitNextButton.setTitle("Next", for: UIControlState.normal)
            }
        }
        else {
            result.text = String("")
            answerChoicesCollection = [0, 0, 0, 0]
            generateMultiplicationValues()
            correctLabel.textColor = UIColor.black
            correctLabel.text = "You are..."
            submitNextButton.setTitle("Submit", for: UIControlState.normal)
            answerChoices.delegate = self
            answerChoices.dataSource = self
        }
        
    }
    
}

