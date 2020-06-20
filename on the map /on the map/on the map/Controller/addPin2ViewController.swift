//
//  addPin2ViewController.swift
//  on the map
//
//  Created by بشاير الخليفه on 19/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import UIKit
import MapKit

class addPin2ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gecodingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showLocation()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitStudentInformation(_ sender: Any) {
        API.postStudentLocation { (success, error, message) in
            DispatchQueue.main.async {
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                     self.alert(title: "Submit Failed", message: message)
                
                }
            }
        }
    }
    
}
extension addPin2ViewController: MKMapViewDelegate {
    
    func showLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(API.UserData.latitude), longitude: CLLocationDegrees(API.UserData.longitude))
        let studentLocation = MKPointAnnotation()
        studentLocation.coordinate = coordinate
        studentLocation.title = "\(API.UserData.firstName) \(API.UserData.lastName)"
        studentLocation.subtitle = API.UserData.mediaURL
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(studentLocation)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
}
