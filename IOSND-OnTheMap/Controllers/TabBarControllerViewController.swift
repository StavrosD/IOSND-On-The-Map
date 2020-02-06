//
//  TabBarControllerViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 31/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController ,CommonCodeProtocol{
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData(self)
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
    @IBAction func unwindToTabBarView(segue:UIStoryboardSegue)
    {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        NetworkClient.logout(completion: handleLogoutResponse)
    }
    func handleLogoutResponse(success: Bool, errorMessage:String?){
        if success {
            removeStudentInformation()
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        } else {
            alert(title: "Error", message: errorMessage!)
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        NetworkClient.loadStudentLocationData(completion: handleLoadDataResponse)
    }
    
    func handleLoadDataResponse(studentInfo: StudentInformations?, errorMessage:String?){
        if let error = errorMessage{
            alert(title: "Error", message: error)
        } else {
            removeStudentInformation()
            addStudentsInformation(studentsInformation: studentInfo!.results)
            
            guard let array = (navigationController?.viewControllers.first as! TabBarControllerViewController).viewControllers else {
                print("no viewcontrollers")
return
            }
            for viewController in array{
                if viewController is TableViewController{
                    (viewController as! TableViewController).tableView.reloadData()
                } else if viewController is MapViewController {
                    (viewController as! MapViewController).drawPins()
                }
            }
        }
    }
}
