//
//  CustomUIViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 29/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import MapKit



protocol CommonCodeProtocol where Self:AlertProtocol{
    var studentInformation:[StudentInformation]! {get}
    
    // Clear the student information
    func removeStudentInformation()
    
    // Open a URL in the default browser, (Safari unless the user selected another one).
    // If the URL is invalid, an error messgage is displayed to the user
    func openURL(url: String?)
        
    // add a new location
    func addStudentInformation(studentInformation:StudentInformation)
    
    // add new locations
     func addStudentsInformation(studentsInformation:[StudentInformation])
    
}

extension CommonCodeProtocol where Self:UIViewController{
    var studentInformation:[StudentInformation]!{
        get{
            let object =  UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.studentInformation
        }
    }
    
    
    // Clear the student information
    func removeStudentInformation(){
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentInformation.removeAll()
    }
    
    // Open a URL in the default browser, (Safari unless the user selected another one).
    // If the URL is invalid, an error messgage is displayed to the user
    func openURL(url: String?){
        if let toOpen =  url {
            if toOpen.isEmpty{
                return
            }
            if !url!.contains(".") || (url!.last == ".") // every valid URL should contain at least one dot and the last character should not be a dot.
            {
                alert(title: "Error", message: "Invalid url!")
                return
            }
            var link:String
            if toOpen.starts(with: "http"){
                link = toOpen
            } else {
                link = "http://" + toOpen
            }
            if let url = URL(string: link )  {
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    // add a new location
    func addStudentInformation(studentInformation:StudentInformation){
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentInformation.append(studentInformation)
    }
    
    // add new locations
    func addStudentsInformation(studentsInformation:[StudentInformation]){
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentInformation.append(contentsOf: studentsInformation)
    }
}
