//
//  MapView.swift
//  SolarX
//

import UIKit
import WebKit
import CDAlertView
import SAConfettiView

class MapView: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webContainerView: UIView!
    var webView: WKWebView!
    
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var percentageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentController = WKUserContentController()
            let script = "var el = document.getElementById('YourDivID'); if (el) el.parentNode.removeChild(el);"
        let scriptInjection = WKUserScript(source: script as String, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
            contentController.addUserScript(scriptInjection)
            let config = WKWebViewConfiguration()
            config.userContentController = contentController
        
        webView = WKWebView(frame: webContainerView.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.scrollView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        self.webContainerView.addSubview(webView)
        let myURL = URL(string: "https://www.calcmaps.com/map-area/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        setupToolbar()
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
                    NotificationCenter.default.addObserver(self, selector: #selector(MapView.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                  
                      // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
                    NotificationCenter.default.addObserver(self, selector: #selector(MapView.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Handling
        @objc func keyboardWillShow(notification: NSNotification) {
                
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }
          
          // move the root view up by the distance of keyboard height
          self.view.frame.origin.y = 0 - keyboardSize.height
        }

        @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
          self.view.frame.origin.y = 0
        }
        
        func setupToolbar(){
            //Create a toolbar
            let bar = UIToolbar()
            //Create a done button with an action to trigger our function to dismiss the keyboard
            let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
            //Create a felxible space item so that we can add it around in toolbar to position our done button
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            //Add the created button items in the toobar
            bar.items = [flexSpace, flexSpace, doneBtn]
            bar.sizeToFit()
            //Add the toolbar to our textfield
            areaField.inputAccessoryView = bar
            percentageField.inputAccessoryView = bar
        }
        
        @objc func dismissMyKeyboard(){
            view.endEditing(true)
        }

    @IBAction func calculateBtnPressed(_ sender: Any) {
        let area = Double(areaField.text ?? "0.0")
        let percentagetemp = Double(percentageField.text ?? "0.0")
        
        if(area == nil || percentagetemp == nil){
            let alert = CDAlertView(title: "Something went wrong", message: "Please enter the calculated details in the field.", type: .error)
            let doneAction = CDAlertViewAction(title: "Sure thing! 🤘")
            alert.add(action: doneAction)
            alert.show()
        } else {
            DispatchQueue.main.async {
                
                // Import custom trained CoreML models
                let costModel = SolarXCost()
                let co2Model = SolarXCO2Mitigation()
                let monthlySavingsModel = SolarXMonthlySavings()
                
                let irridation = 1046.26
                
                // Installation Cost Model Prediction
                guard let costModelOutput = try? costModel.prediction(Total_Roof_Top_Area__in_Sq__m__: area!, Percent_of_Roof_Top_Area_available: percentagetemp!) else {
                    fatalError("Unexpected runtime error.")
                }
                
                let cost = costModelOutput.Installation_Cost
                
                globalInstallation = globalInstallation + cost.rounded(toPlaces: 2)
                
                // Lifetime CO2 Mitigation Model Prediction
                guard let co2ModelPred = try? co2Model.prediction(Total_Roof_Top_Area__in_Sq__m__: area!, Percent_of_Roof_Top_Area_available: percentagetemp!, Average_Solar_Irridation__W_sq_m_: irridation) else {
                    fatalError("Unexpected runtime error.")
                }
                
                let co2Mitigation = co2ModelPred.Lifetime_CO2_Mitigation__mt_
                
                globalCO2Mitigation = globalCO2Mitigation + co2Mitigation.rounded(toPlaces: 2)
                
                // Monthly Savings Model Prediction
                guard let monthlySavingsPrediction = try? monthlySavingsModel.prediction(Total_Roof_Top_Area__in_Sq__m__: area!, Percent_of_Roof_Top_Area_available: percentagetemp!, Average_Solar_Irridation__W_sq_m_: irridation) else {
                    fatalError("Unexpected runtime error.")
                }
                
                let monthlySavings = monthlySavingsPrediction.Monthly_Savings
                print(monthlySavings)
                
                globalCostSaving = globalCostSaving + monthlySavings.rounded(toPlaces: 2)
            }


            let confettiView = SAConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)

            confettiView.startConfetti()
            
            let alert = CDAlertView(title: "Yay!", message: "Welcome to the green revolution with SolarX. ", type: .success)
            alert.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:true, completion:nil)
            })
        }
    }
}
