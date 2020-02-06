//
//  VerifyAddLocationViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 30/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import MapKit

class VerifyAddLocationViewController: UIViewController,AlertProtocol, CommonCodeProtocol,MKMapViewDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationAddress:String!
    var url:String!
    var geocoder:CLGeocoder!
    var studentInfo:StudentInformation!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        geocoder = CLGeocoder()
        getLocation()
        studentInfo=StudentInformation(createdAt: "", firstName: "Stavros", lastName: "Dim", latitude: 0.0, longitude: 0.0, mapString: locationAddress, mediaURL: url, objectId: "", uniqueKey: "", updatedAt: "")
        mapView.delegate=self
        activityIndicator.startAnimating()
    }
    
    func getLocation()
    {
        geocoder.geocodeAddressString( locationAddress , completionHandler: {(locations, error) in
            self.activityIndicator.stopAnimating()
            if error != nil {
                self.alert(title: "Error", message: error?.localizedDescription ?? "Unknown error!")
                self.performSegue(withIdentifier: "unwindToAddLocation", sender: self)
            }
            if locations != nil{
                let geocodedLocation  = locations?.first
                self.mapView.removeAnnotations(self.mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = (geocodedLocation?.location!.coordinate)!
                annotation.title  = self.locationAddress
                annotation.subtitle=" "
                self.mapView.addAnnotation(annotation)
                self.mapView.centerCoordinate = annotation.coordinate
                self.mapView.selectAnnotation(annotation, animated:true)
                self.studentInfo.longitude = annotation.coordinate.latitude
                self.studentInfo.latitude = annotation.coordinate.latitude
            } else {
                self.alert(title: "Error",message: "Cannot find the location!")
                self.performSegue(withIdentifier: "unwindToAddLocation", sender: self)
            }
        })}
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.calloutOffset=CGPoint(x: 0, y: 0)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type:.custom) as UIView
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let calloutView = view.subviews.first else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped(_:)))
        calloutView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func annotationTapped(_ sender: UITapGestureRecognizer) {
        if let annotationView = sender.view?.superview as? MKPinAnnotationView
        {
            openURL(url: annotationView.annotation?.subtitle!)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        NetworkClient.postLocation(uniqueKey: studentInfo.uniqueKey, firstName: studentInfo.firstName, lastName: studentInfo.lastName, locationAddress: studentInfo.mapString, url: studentInfo.mediaURL, latitude: String(studentInfo.latitude), longitude: String(studentInfo.longitude), completion: handlePostRequest)
        
    }
    
    func handlePostRequest(success:Bool, errorMessage:String?){
        if success{
        self.performSegue(withIdentifier: "unwindToTabController", sender: self)
        } else {
            alert(title:"Error",message: errorMessage!)
        }
    }
}
