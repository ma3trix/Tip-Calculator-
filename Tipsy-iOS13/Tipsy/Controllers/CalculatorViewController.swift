//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var billTextField:
    UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    var finalResult = ""
    
    @IBAction func tipChanged(_ sender: UIButton) {
 
        billTextField.endEditing(true)
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
        let buttonTitle = sender.currentTitle!
        let numButton = buttonTitle.dropLast()
        let tipSelected = Double(numButton)!
        
        tip = tipSelected / 100

        
        sender.isSelected = true

    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        numberOfPeople = Int(sender.value)
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        if let bill = billTextField.text {
            billTotal = Double(bill)!
            let amt =  billTotal * (1 + tip) / Double(numberOfPeople)
            finalResult = String(format: "%.2f", amt)
            print(amt)
            print(tip)
            print(tip + 1)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destinationVC = segue.destination as! ResultsViewController
                destinationVC.results = finalResult
                destinationVC.split = numberOfPeople
                destinationVC.tips = Int(tip)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

