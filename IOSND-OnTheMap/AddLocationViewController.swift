//
//  AddLocationViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 30/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit

class AddLocationViewController: CustomTextFieldViewController, AlertProtocol {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "verifyLocationSegue"{
            
            if locationTextField.text?.isEmpty ?? true {
                self.alert(title: "Warning", message: "Please enter a location!")
                return false
            }
            
            if urlTextField.text?.isEmpty ?? true {
                self.alert(title: "Warning", message: "Please enter a URL!")
                return false
            }
            
            if let url = urlTextField.text {
                if url.contains(".") && (url.last != ".") {
                    return true
                }
            }
            self.alert(title: "Warning", message: "Incorrect URL!")
            return false
        }        else { return true }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyLocationSegue"{
            let viewController = segue.destination as! VerifyAddLocationViewController
            viewController.locationAddress = locationTextField.text
            viewController.url = urlTextField.text

        }
    }
    
    
    // cancel is used to unwind the segue from the next viewcontroller
    @IBAction func cancel (_ unwindSegue: UIStoryboardUnwindSegueSource){
        
    }
    @IBAction func cancelToTab(_ unwindSegue: UIStoryboardSegue){
              performSegue(withIdentifier: "unwindSegue", sender: self)
       // }
        
    }
}
