//
//  addPinViewController.swift
//  on the map
//
//  Created by بشاير الخليفه on 19/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//


import UIKit
import CoreLocation

class AddPinViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaTextField: UITextField!
   @IBOutlet weak var geocodingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        mediaTextField.delegate = self
        locationTextField.text = ""
        mediaTextField.text = ""
 
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let location = locationTextField.text,
            let medialink = mediaTextField.text,
            location != "",
            medialink != "" else {
                 self.alert(title: "Missing information", message: "please fill both fields and try again")
               
                return
            }
        geocodingIndicator.startAnimating()
        getCoordinateFrom(address: locationTextField.text ?? "") { (coordinate, error) in
            guard let coordinate = coordinate else {
                DispatchQueue.main.async {
               self.geocodingIndicator.stopAnimating()
               self.alert(title: "Add Pin Failed", message: "Enter a correct location!")
            
                }
                return
            }
            DispatchQueue.main.async {
                API.UserData.latitude = coordinate.latitude
                API.UserData.longitude = coordinate.longitude
                API.UserData.mapString = location
                API.UserData.mediaURL = medialink
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirmPin") as! addPin2ViewController
                self.geocodingIndicator.stopAnimating()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1)}
    }
    
 
    
}

