//
//  API.swift
//  on the map
//
//  Created by بشاير الخليفه on 16/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import Foundation




public class API {
    
    struct UserData {
          static var firstName = ""
          static var lastName = ""
          static var longitude = 0.0
          static var latitude = 0.0
          static var mapString = ""
          static var mediaURL = ""
          static var uniqueKey = ""
          static var objectId = ""
          static var didPost = false
      }
      
enum EndPoints {
    case getStudentLocation
    case session
    case postStudentLocation
    case logout
    
    var stringValue: String {
        switch self {
        case .getStudentLocation:
            return "https://onthemap-api.udacity.com/v1/StudentLocation"
        case .session:
            return "https://onthemap-api.udacity.com/v1/session"
        case .postStudentLocation:
            return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        case .logout:
            return "https://onthemap-api.udacity.com/v1/session"
        }
    }
    
    var url: URL {
        return URL(string: self.stringValue)!
    }
}
    
    static func chekError(error: Error?, response: URLResponse?) -> String? {
           if error != nil {
               return error?.localizedDescription
           }
           
           guard let statusCode = (response as? HTTPURLResponse)?.statusCode
               else {
               let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                   return statusCodeError.localizedDescription
           }
           guard statusCode >= 200 && statusCode <= 299 else {
               var errorMessage = ""
               switch statusCode {
               case 400:
                   errorMessage = "Bad Request"
               case 401:
                   errorMessage = "Invalid Credentials"
               case 403:
                   errorMessage = "Unauthrized"
               case 405:
                   errorMessage = "HTTP Method Not Allowed"
               case 410:
                   errorMessage = "URL Changed"
               case 500:
                   errorMessage = "Server Error"
               default:
                   errorMessage = "Try again"
               }
               return errorMessage
           }
           return nil
       }
       
    
class func createSession(email: String, password: String, completion: @escaping (Bool, Error?, String) -> Void) {
    var request = URLRequest(url: EndPoints.session.url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
         if let errorDescription = chekError(error: error, response: response) {
              completion(false , error , errorDescription)
                     return
                 }

        guard let data = data else {completion(false, error, error?.localizedDescription ?? ""); return}
         let subData = data[5..<data.count]
       
          let jsonObject = try! JSONSerialization.jsonObject(with: subData, options: [])
            let  json = jsonObject as! [String: Any]
            let accountDictionary = json ["account"] as? [String : Any]
           if (accountDictionary? ["key"] as? String) != nil {
            completion (true, nil, "")
          }else{
            guard let errorDescription = json["error"] as? String else {return}
            completion(false , error , errorDescription)}
   
    }
    task.resume()
    }
    
    class func getAllLocations(completion: @escaping ([UsersInfo], Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.getStudentLocation.url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error != nil {
            completion([], error)}
            
            guard let data = data else {completion([], error); return}
           
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
            let jsonDict = jsonObject as! [String: Any]
            
            if let resultsArray = jsonDict["results"] as? [[String:Any]]{
                let dataObject = try! JSONSerialization.data(withJSONObject: resultsArray, options: .prettyPrinted)
                let studentsLocations = try! JSONDecoder().decode([UsersInfo].self, from: dataObject)
                completion(studentsLocations,nil)
            }else {completion([], error)}
        }
        task.resume()
    }
   class func postStudentLocation(completion: @escaping (Bool, Error?, String) -> Void) {
         var request = URLRequest(url: EndPoints.postStudentLocation.url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = "{\"uniqueKey\": \"\(UserData.uniqueKey)\", \"firstName\": \"\(UserData.firstName)\", \"lastName\": \"\(UserData.lastName)\",\"mapString\": \"\(UserData.mapString)\", \"mediaURL\": \"\(UserData.mediaURL)\",\"latitude\": \(UserData.latitude), \"longitude\": \(UserData.longitude)}".data(using: .utf8)
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {completion(false, error, error?.localizedDescription ?? ""); return}
             do {
             let object = try JSONDecoder().decode(PostStudentResponse.self, from: data)
                 AddedStudent.students.append(UsersInfo(firstName: UserData.firstName, lastName: UserData.lastName, longitude: UserData.longitude, latitude: UserData.latitude, mapString: UserData.mapString, mediaURL: UserData.mediaURL, uniqueKey: UserData.uniqueKey, objectId: object.objectId))
                
                 completion(true,nil, "")
             } catch {completion(false, error, error.localizedDescription)}
         }
         task.resume()
     }
    
    
    class func deletesSession(completion: @escaping (Bool, Error?) -> Void) {
            var request = URLRequest(url: EndPoints.logout.url)
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
                guard let _ = data else {
                    DispatchQueue.main.async {
                        completion(false, error!)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            task.resume()
    }
}

