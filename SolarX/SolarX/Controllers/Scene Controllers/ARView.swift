//
//  ARView.swift
//  SolarX
//

import UIKit
import SceneKit
import ARKit
import CDAlertView
import SVProgressHUD
import SAConfettiView
import CoreML

var supremeArea = 0.0
var percentage = 0.0

class ARView: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var snapBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    var percentageLabel: UITextField!
    
    var grids = [Grid]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "redSnap.png") {
            snapBtn.setImage(image, for: .normal)
        }
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        supremeArea = 0.0
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func snapBtnPressed(_ sender: Any) {
        if(supremeArea == 0.0){
            
            let alert = CDAlertView(title: "Something went wrong", message: "No horizontal plane detected. Please try again.", type: .error)
            alert.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:true, completion:nil)
            })

        } else {

            displayForm(message: "A few more details. What percentage of this area do you want to use for solar installation?")

        }
    }
    
    func displayForm(message:String){
            //create alert
            let alert = UIAlertController(title: "Installation Cost Estimator", message: message, preferredStyle: .alert)
            
            //create cancel button
            let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
            
            //create save button
            let saveAction = UIAlertAction(title: "Submit", style: .default) { (action) -> Void in
               //validation logic goes here
                if((self.percentageLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!){
                    //if this code is run, that mean at least of the fields doesn't have value
                    self.percentageLabel.text = ""
                    
                    self.displayForm(message: "One of the values entered was invalid. Please enter accurate information.")
                }
                
                DispatchQueue.main.async {
                    percentage = Double(self.percentageLabel.text!)!

                    DispatchQueue.main.async {
                        
                        // Import custom trained CoreML models
                        let costModel = SolarXCost()
                        let co2Model = SolarXCO2Mitigation()
                        let monthlySavingsModel = SolarXMonthlySavings()
                        
                        let irridation = 1046.26
                        
                        // Installation Cost Model Prediction
                        guard let costModelOutput = try? costModel.prediction(Total_Roof_Top_Area__in_Sq__m__: supremeArea, Percent_of_Roof_Top_Area_available: percentage) else {
                            fatalError("Unexpected runtime error.")
                        }
                        
                        let cost = costModelOutput.Installation_Cost
                        
                        globalInstallation = globalInstallation + cost.rounded(toPlaces: 2)
                        
                        // Lifetime CO2 Mitigation Model Prediction
                        guard let co2ModelPred = try? co2Model.prediction(Total_Roof_Top_Area__in_Sq__m__: supremeArea, Percent_of_Roof_Top_Area_available: percentage, Average_Solar_Irridation__W_sq_m_: irridation) else {
                            fatalError("Unexpected runtime error.")
                        }
                        
                        let co2Mitigation = co2ModelPred.Lifetime_CO2_Mitigation__mt_
                        
                        globalCO2Mitigation = globalCO2Mitigation + co2Mitigation.rounded(toPlaces: 2)
                        
                        // Monthly Savings Model Prediction
                        guard let monthlySavingsPrediction = try? monthlySavingsModel.prediction(Total_Roof_Top_Area__in_Sq__m__: supremeArea, Percent_of_Roof_Top_Area_available: percentage, Average_Solar_Irridation__W_sq_m_: irridation) else {
                            fatalError("Unexpected runtime error.")
                        }
                        
                        let monthlySavings = monthlySavingsPrediction.Monthly_Savings
                        
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
            
            //add button to alert
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            //create first name textfield
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "What percentage will be in use?"
                textField.keyboardType = .decimalPad
                self.percentageLabel = textField
            })
            
            self.present(alert, animated: true, completion: nil)
        }
    
    // MARK: - ARSCNViewDelegate
        
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present an error message to the user
            
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // Inform the user that the session has been interrupted, for example, by presenting an overlay
            
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // Reset tracking and/or remove existing anchors if consistent tracking is required
            
        }
        
        // 1.
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            let grid = Grid(anchor: anchor as! ARPlaneAnchor)
            self.grids.append(grid)
            node.addChildNode(grid)
            if let image = UIImage(named: "greenSnap.png") {
                DispatchQueue.main.async {
                    self.snapBtn.setImage(image, for: .normal)
                }
            }
        }
    
        // 2.
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            let grid = self.grids.filter { grid in
                return grid.anchor.identifier == anchor.identifier
            }.first
            
            guard let foundGrid = grid else {
                return
            }
            
            foundGrid.update(anchor: anchor as! ARPlaneAnchor)
        }

}
