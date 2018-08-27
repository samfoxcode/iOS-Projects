//
//  ViewController.swift
//  Multiplication Exercises
//
//  Created by Samuel Fox on 8/25/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var multiplicand: UILabel!
    @IBOutlet var multiplier: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var questionsStatus: UILabel!
    @IBOutlet var submitNextButton: UIButton!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var answerChoicesSegmentedControl: UISegmentedControl!
    @IBOutlet var progressBar: UIProgressView!
    
    var internalResultCollection = [Int]()
    let numberOfChoicesDisplayed = 5
    var internalMultiplicand = 0
    var internalMultiplier = 0
    var internalResult = 0
    var attempts = 0
    var totalCorrect = 0
    

    func generateMultiplicationValues(){
        var randomResult = 0
        internalResultCollection = [Int]()
        
        internalMultiplicand = Int(arc4random_uniform(15)+1)
        internalMultiplier = Int(arc4random_uniform(15)+1)
        multiplicand.text = String(internalMultiplicand)
        multiplier.text = String(internalMultiplier)
        internalResult = internalMultiplicand * internalMultiplier
        
        // Populate a collection of random results as well as the correct one for internal use
        while internalResultCollection.count < numberOfChoicesDisplayed {
            if Int(arc4random_uniform(2)) == 1 {
                randomResult = internalResult + Int(arc4random_uniform(5))+1
            }
            else {
                randomResult = internalResult - Int(arc4random_uniform(5))+1
            }
            if !(internalResultCollection.contains(randomResult)) && randomResult != internalResult && randomResult > 0{
                internalResultCollection.append(randomResult)
            }
        }
        // Put the correct value randomly in the array
        internalResultCollection[Int(arc4random_uniform(4))] = internalResult
        
        var index = 0
        answerChoicesSegmentedControl.removeAllSegments()
        for i in internalResultCollection {
            answerChoicesSegmentedControl.insertSegment(withTitle: String(i), at: index, animated: true)
            index += 1
        }
        
    }
    
    func startAndRestartGame(){
        // Initialize all values to their start value.
        answerChoicesSegmentedControl.isEnabled = true
        answerChoicesSegmentedControl.selectedSegmentIndex = -1
        progressBar.progress = 0
        internalMultiplicand = 0
        internalMultiplier = 0
        internalResult = 0
        attempts = 0
        totalCorrect = 0
        internalResultCollection = [Int]()
        questionsStatus.text = "\(totalCorrect)/\(attempts) Questions Correct"
        result.text = String("___")
        correctLabel.textColor = UIColor.black
        correctLabel.text = "You are..."
        submitNextButton.setTitle("Submit", for: UIControlState.normal)
        submitNextButton.isEnabled = false
        
        generateMultiplicationValues()

    }

    @IBAction func segmentedControlAction(_ sender: Any) {
        submitNextButton.isEnabled = true
    }
    
    @IBAction func submitAndNextButton(_ sender: Any) {
        
        if submitNextButton.currentTitle == "Submit" {
            let selectedChoice = answerChoicesSegmentedControl.selectedSegmentIndex
            answerChoicesSegmentedControl.isEnabled = false
            result.text = String(internalResult)
                
            if internalResultCollection[selectedChoice] != internalResult {
                correctLabel.textColor = UIColor.red
                correctLabel.text = "Wrong!"
                attempts = attempts + 1
            }
            else {
                correctLabel.textColor = UIColor.green
                correctLabel.text = "Correct!"
                attempts = attempts + 1
                totalCorrect = totalCorrect + 1
                progressBar.progress = progressBar.progress + 0.2
            }
                
            questionsStatus.text = "\(totalCorrect)/\(attempts) Questions Correct"
                
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
            result.text = String("___")
            internalResultCollection = [Int]()
            generateMultiplicationValues()
            correctLabel.textColor = UIColor.black
            correctLabel.text = "You are..."
            submitNextButton.setTitle("Submit", for: UIControlState.normal)
            submitNextButton.isEnabled = false
            answerChoicesSegmentedControl.isEnabled = true
            answerChoicesSegmentedControl.selectedSegmentIndex = -1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAndRestartGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

