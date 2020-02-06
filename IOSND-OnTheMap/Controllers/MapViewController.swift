//
//  MapViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 27/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate, CommonCodeProtocol {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The data should be already downloaded when the table view controller loaded, before the map view is displayed. We only have to draw the pins.
     drawPins()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type:.custom)
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
    
    func drawPins(){
        if mapView != nil {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        for pin in studentInformation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = "\(pin.firstName) \(pin.lastName)"
            annotation.subtitle = pin.mediaURL
            mapView.addAnnotation(annotation)
        }
        }
    }
}
