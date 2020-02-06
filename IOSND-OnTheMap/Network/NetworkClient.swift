//
//  NetworkClient.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 31/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation

class NetworkClient{
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(responseType.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func login(username:String, password:String, completion: @escaping (Bool, String?)->Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error?.localizedDescription)
                }
                return
            }
            let range = 5..<data!.count // ignore the first 5 characters
            let newData = data!.subdata(in: range)/* subset response data! */
            if let authDetails = try? JSONDecoder().decode(UdacityAuth.self,from:newData) {
                if let account = authDetails.account{
                    if account.registered{
                        DispatchQueue.main.async {
                            completion(true,nil)
                        }
                        return
                    }
                }
                else{
                    if let err = authDetails.error{
                        DispatchQueue.main.async {
                            completion(false,err)
                        }
                        return
                    }
                    else{
                        DispatchQueue.main.async {
                            completion(false, "Unknown error")
                        }
                        return
                    }
                }
            }
        }
        task.resume()
    }
    
    class func loadStudentLocationData(completion: @escaping (StudentInformations?, String?)->Void){
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil,error?.localizedDescription)
                }
                return
            }
            if data!.count == 0 { // no data available
                
                DispatchQueue.main.async {
                    completion(nil,"No data available!")
                }
                return
            }
            if let locations = try? JSONDecoder().decode(StudentInformations.self, from: data!){
                //if we we have the student locations
                DispatchQueue.main.async {
                    completion(locations,nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    completion(nil,"Cannot parse results!")
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, String?)->Void){
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
                DispatchQueue.main.async {
                    completion(false, error?.localizedDescription)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true,nil)
            }
            return
        }
        task.resume()
    }
    
    class func postLocation (uniqueKey:String, firstName:String, lastName:String, locationAddress:String,url:String, latitude:String, longitude: String, completion:@escaping (Bool, String?)->Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationAddress)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false,error!.localizedDescription)
                    return
                }
            }
            if let data = data{
                if let _ = try? JSONDecoder().decode(PostResponse.self, from: data){  // if postResponse can be parsed as Postresponse, the post was successful
                    DispatchQueue.main.async{
                        completion(true,nil)
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, "unknown error")
                        return
                    }
                }
            }}
        
        task.resume()
    }
}
