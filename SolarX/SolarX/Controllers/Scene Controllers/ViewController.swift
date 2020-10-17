//
//  ViewController.swift
//  SolarX
//

import UIKit
import CoreML
import CoreData
import CDAlertView
import SAConfettiView

var globalCO2Mitigation = 0.0
var globalCostSaving = 0.0
var globalInstallation = 0.0

class ViewController: UIViewController {

    @IBOutlet weak var lifetimesavingsLbl: UILabel!
    @IBOutlet weak var savingsTodayLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    
    // Import custom trained CoreML models
    let costModel = SolarXCost()
    let co2Model = SolarXCO2Mitigation()
    let monthlySavingsModel = SolarXMonthlySavings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thisDay = Double(globalCostSaving / 30.00)
        savingsTodayLbl.text = String(Double(round(1000*thisDay)/1000))
        lifetimesavingsLbl.text = "₹ \(String(globalCostSaving * 12 * 25))"
    }

    
    // MARK: IBActions
    @IBAction func arBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func siriBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func greenbtnpressed(_ sender: Any) {
        if(globalCO2Mitigation == 0.0){
            //create alert
            let alert = UIAlertController(title: "Lifetime CO2 Mitigation", message: "You don't have any solar installations at the moment. Now's a good time to start.", preferredStyle: .alert)
            
            //create save button
            let saveAction = UIAlertAction(title: "Sure thing!", style: .default) { (action) -> Void in
            }
            
            //add button to alert
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let confettiView = SAConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)

            confettiView.startConfetti()
            
            //create alert
            let alert = UIAlertController(title: "Lifetime CO2 Mitigation", message: "Your current solar installations amount to a total lifetime C02 mitigation of \(globalCO2Mitigation) metric tonnes.", preferredStyle: .alert)
            
            //create save button
            let saveAction = UIAlertAction(title: "Woohoo 🤘", style: .default) { (action) -> Void in
                DispatchQueue.main.async {
                    confettiView.stopConfetti()
                }
            }
            
            //add button to alert
            alert.addAction(saveAction)
            
            self.present(alert, animated: true, completion: nil)
        }


    }
    
}
