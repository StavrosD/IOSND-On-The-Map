//
//  UdacityAPIStruct.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 26/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation


struct UdacityAuth: Codable {  // if the cedentials are valid, JSONDecoder will get the values for the account and session variables. If the credantials are invalid, it will get the values for the status and the error.
    var account: Account?
    var session: Session?
    var status: Int?
    var error: String?
}

struct Account: Codable{
    var registered: Bool
    var key: String
}

struct Session: Codable
{
   var id: String
    var expiration: String
}
