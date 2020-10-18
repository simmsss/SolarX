//
//  ViewController.swift
//  SolarX
//

import UIKit
import CoreML
import CoreData
import CDAlertView
import SAConfettiView
import Alamofire

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
        
        let apiKey = "AIzaSyAHnPMCDdWU8YfAJEPRXX7thrdXvz9nCsE"
        
        let url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=mongolian%20grill&inputtype=textquery&fields=photos,formatted_address,name,opening_hours,rating&locationbias=circle:2000@47.6918452,-122.2226413&key=\(apiKey)"
        
        AF.request(url, method: .get).response { data in
            print(data)
        }
    }

    
    // MARK: IBActions
    @IBAction func arBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func siriBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func northIndiaCampaigns(_ sender: Any) {
        let alert = UIAlertController(title: "North India Subsidies", message: "Please select your state of residence", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Uttar Pradesh", style: .default, handler: { (_) in
            self.showAlertWithThreeButton(alert: "Uttar Pradesh", message: "The state government announced a subsidy of Rs 15,000 per kW for the development of rooftop solar projects which will be provided to residential consumers.", url: "https://upnedasolarrooftopportal.com/Apply-Online")
        }))
        
        alert.addAction(UIAlertAction(title: "Haryana", style: .default, handler: { (_) in
            self.showAlertWithThreeButton(alert: "Haryana", message: " If you are getting bills between Rs. 2000-3000 then your average cost is Rs. 7/ from using solar you get it as Rs. 2/unit. 90% subsidy available for farmers on water pumping systems.", url: "www.hareda.gov.in")
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func showAlertWithThreeButton(alert: String, message: String, url: String) {
            let alert = UIAlertController(title: alert, message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { (_) in
                guard let url = URL(string: url) else { return }
                UIApplication.shared.open(url)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

            }))

            self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func centralIndiaCampaigns(_ sender: Any) {
        let alert = UIAlertController(title: "Central India Subsidies", message: "Please select your state of residence", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Madhya Pradesh", style: .default, handler: { (_) in
            self.showAlertWithThreeButton(alert: "Madhya Pradesh", message: "For 3 KW capacity, 40% is being provided in financial assistance. RTS system (Rooftop System) upto 3 kW up to capacity and 10 KW, subsidizing 20% to be provided.", url: "https://cdn.shopify.com/s/files/1/2980/5140/files/Tender_Document_for_Design_Supply_Installation_Testing_Commissioning_and_Maintenance_of_45_MW.pdf?v=1587361578")
        }))
        
        alert.addAction(UIAlertAction(title: "Maharashtra", style: .default, handler: { (_) in
            self.showAlertWithThreeButton(alert: "Maharashtra", message: "The subsidy available on the installation of grid-connected solar rooftop power plants is 30% of the benchmark cost. Government institutions including PSUs shall not be eligible for the subsidy. Instead, they will be given achievement-linked incentives/awards. All residential and institutional buildings such as schools, health institutions, etc. and the social sector can avail CFA.", url: "https://www.mahaurja.com/meda/grid_connected_power/solar_power/state_policy")
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @IBAction func southIndiaCampaigns(_ sender: Any) {
        let alert = UIAlertController(title: "Central India Subsidies", message: "Please select your state of residence", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Kerela", style: .default, handler: { (_) in
            self.showAlertWithThreeButton(alert: "Kerela", message: "For group housing society projects and residential welfare associations, with a capacity up to 500 kW, the center will provide a subsidy of 20%. If a customer wishes to install the plant investing the whole amount, they can choose to avail up to 40% of plant cost as subsidy.", url: "https://wss.kseb.in/selfservices/wss-registerForm")
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @IBAction func contractsBtnPressed(_ sender: Any) {
        
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
