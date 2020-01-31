//
//  LoginViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 26/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit

class LoginViewController: CustomTextFieldViewController,CommonCodeProtocol {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   override func viewDidLoad() {
       super.viewDidLoad()
       activityIndicator.isHidden=true
       // Do any additional setup after loading the view.
   }
    
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text?.isEmpty ?? true
        {
            alert(title: "Cannot login!",message: "Please enter your email!")
            return
        }
        if passwordTextField.text?.isEmpty ?? true {
            alert(title: "Cannot login!",message: "Please enter your password!")
            return
        }
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                self.alert(title: "Error", message: error!.localizedDescription)
                return
            }
            if data!.count<=10 // the first letters are ignored, we have some brackets and comas, the response should have more than 10 characters
            {
                return
            }
            let range = 5..<data!.count // ignore the first 5 characters
            let newData = data!.subdata(in: range)/* subset response data! */
            if let authDetails = try? JSONDecoder().decode(UdacityAuth.self,from:newData) {
                if let account = authDetails.account{
                    if account.registered{
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                        return
                    }
                }
                else{
                    if let error = authDetails.error{
                        self.alert(title: "Login error", message: error)
                        return
                    }
                    else{
                        self.alert(title: "Unknown error", message: "Cannot login!")
                    }
                }
            }
            else{
                self.alert(title: "Unknown error", message: "Cannot login!")
            }
        }
        task.resume()
    }
    @IBAction func unwindToLogin (_ unwindSegue: UIStoryboardSegue){
     logout()
    }
    @IBAction func signUpButton(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url)
        }
    }
    
}
