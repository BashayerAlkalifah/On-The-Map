//
//  ListVC.swift
//  on the map
//
//  Created by بشاير الخليفه on 18/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import Foundation

import UIKit

class ListVC: UITableViewController {

    var studentsLocations = [UsersInfo]()
    
    override func viewDidLoad() {
     API.getAllLocations(completion: getStudentLocationHelper(studentLocations:error:))
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         tableView.reloadData()
     }
     
    @IBAction func logout(_ sender: Any) {
        API.deletesSession() { success, error in
               if success {
                   self.dismiss(animated: true, completion: nil)
               } else {
                self.alert(title: "Logout Failed", message: error!.localizedDescription )
             
               }
           }
        
        
    }
    @IBAction func addPin(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
         present(vc, animated: true, completion: nil)
        
    }
 
    func getStudentLocationHelper(studentLocations: [UsersInfo], error: Error?) {
        if error == nil {
            DispatchQueue.main.async {
                self.studentsLocations = studentLocations
                self.studentsLocations.append(contentsOf: AddedStudent.students)
                self.tableView.reloadData()
            }
        } else {
           self.alert(title: "Network Issue", message: "There was an error loading locations")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: studentsLocations[indexPath.row].mediaURL)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }


}
