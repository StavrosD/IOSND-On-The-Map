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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
  
    
    
    
    @IBAction func cancelToMapView( _ unwindsegue:UIStoryboardUnwindSegueSource){
        
    }
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    
    @IBAction func refreshMap(_ sender: Any) {
        
        downloadData(callBack: drawPins)
    }
    
    func drawPins(){
        mapView.removeAnnotations(mapView.annotations)
        for pin in studentInformation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = "\(pin.firstName) \(pin.lastName)"
            annotation.subtitle = pin.mediaURL
            mapView.addAnnotation(annotation)
        }
    }
    
 
    @IBAction func cancel( _ unwindSegue:UIStoryboardUnwindSegueSource){
      }
    
    
}
