//
//  MapViewController.swift
//  on the map
//
//  Created by بشاير الخليفه on 17/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
     @IBOutlet var mapView: MKMapView!
     var studentLocations = [UsersInfo]()
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         mapView.delegate = self
       
     }
    override func viewWillAppear(_ animated: Bool) {
          API.getAllLocations(completion: getStudentLocationHelper(studentLocations:error:))
       }
    
    @IBAction func addPin(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
               vc.modalPresentationStyle = .fullScreen
               present(vc, animated: true, completion: nil)
        
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

   
     
     func getStudentLocationHelper(studentLocations: [UsersInfo], error: Error?) {
         if error == nil {
             DispatchQueue.main.async {
                 self.studentLocations = studentLocations
                 self.studentLocations.append(contentsOf: AddedStudent.students)
                 self.setStudentLocations()
             }
         } else {

            self.alert(title: "Network Issue", message: "There was an error loading locations")
           
             }
         }
     
     func setStudentLocations() {
         mapView.removeAnnotations(mapView.annotations)
         var studentAnnotations = [MKPointAnnotation]()
         for dictionary in studentLocations {
                     let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(dictionary.latitude), longitude: CLLocationDegrees(dictionary.longitude))
                     let studentLocation = MKPointAnnotation()
                     studentLocation.coordinate = coordinate
                     studentLocation.title = "\(dictionary.firstName) \(dictionary.lastName)"
                     studentLocation.subtitle = dictionary.mediaURL
                     studentAnnotations.append(studentLocation)
                }
                self.mapView.addAnnotations(studentAnnotations)
     }
     
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let reuseId = "pin"
         var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
         if pinView == nil {
             pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
             pinView!.isEnabled = true
             pinView!.canShowCallout = true
             pinView!.pinTintColor = .red
             pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
         }
         else {
             pinView!.annotation = annotation
         }
         return pinView
     }
     
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         if control == view.rightCalloutAccessoryView {
             guard let subtitle = view.annotation?.subtitle else {return}
             let url = URL(string: subtitle!)
             UIApplication.shared.open(url!, options: [:], completionHandler: nil)
         }
     }
 }





