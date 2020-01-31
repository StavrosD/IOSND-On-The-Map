//
//  GetStudentLocationsAPIStruct.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 28/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
struct StudentInformations:Codable {
   var results:[StudentInformation]
}

struct StudentInformation:Codable {
    var createdAt:String
    var firstName:String
    var lastName:String
    var latitude: Double
    var longitude:Double
    var mapString:String
    var mediaURL: String
    var objectId:String
    var uniqueKey:String
    var updatedAt:String
}

struct PostResponse:Codable{
    var createdAt:String
    var objectId: String
    }

