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
    
    // Download the data from the server
    func downloadData( callBack:(()->())?)
    
    // Open a URL in the default browser, (Safari unless the user selected another one).
    // If the URL is invalid, an error messgage is displayed to the user
    func openURL(url: String?)
    
    // Clears the downloaded info and displays the login view
    func logout()
    
    // add a new location
    func addStudentInformation(studentInformation:StudentInformation)
    
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
    
    // Download the data from the server
    func downloadData( callBack:(()->())?)
    {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                self.alert(title: "Error", message: error!.localizedDescription)
                return
            }
            if data!.count == 0 { // no data available
                return
            }
            if let locations = try? JSONDecoder().decode(StudentInformations.self, from: data!){
                //if we we have the student locations
                DispatchQueue.main.async {
                    //  if Self.appDelegate.studentLocations.isEmpty {return}
                    (UIApplication.shared.delegate as! AppDelegate).studentInformation.append(contentsOf: locations.results)
                    callBack?()
                    
                }
            }
            else
            {
                self.alert(title:"Error",message:"Cannot parse parse data")
            }
        }
        task.resume()
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
    
    // Clears the downloaded info and displays the login view
    func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                self.alert(title: "Error!", message: "Problem during logout: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            // let range = 5..<data!.count
            //let newData = data?.subdata(in: range) /* subset response data! */
            self.removeStudentInformation()
        }
        task.resume()
    }
    // add a new location
    func addStudentInformation(studentInformation:StudentInformation){
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.studentInformation.append(studentInformation)
    }
}
