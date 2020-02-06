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
   override func viewDidLoad() {
       super.viewDidLoad()
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
        NetworkClient.login(username: emailTextField.text! , password: passwordTextField.text!, completion: handleLoginResponse)
    }
    func handleLoginResponse(success: Bool, errorMessage:String?){
        if success {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        else {
            alert(title: "Login error", message: errorMessage!)
        }
    }
    @IBAction func unwindToLogin(segue:UIStoryboardSegue){
        
    }
    @IBAction func signUpButton(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(url)
        }
    }
    
}
