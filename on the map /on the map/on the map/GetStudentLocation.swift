//
//  GetStudentLocation.swift
//  on the map
//
//  Created by بشاير الخليفه on 17/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import Foundation

struct UsersInfo: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    
}



struct AddedStudent {
    static var students = [UsersInfo]()
}

struct PostStudentResponse: Codable {
    let objectId: String
}

