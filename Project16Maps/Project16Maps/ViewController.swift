//
//  ViewController.swift
//  Project16Maps
//
//  Created by Connor Lee on 15/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var mapTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founed over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often call the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))
        mapTypes.append(".standard")
        mapTypes.append(".mutedStandard")
        mapTypes.append(".satellite")
        mapTypes.append(".satelliteFlyover")
        mapTypes.append(".hybrid")
        mapTypes.append(".hybridFlyover")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.pinTintColor = UIColor.init(red: 0, green: 0, blue: 1, alpha: 1)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func typeTapped() {
        let ac = UIAlertController(title: "Change map type", message: nil, preferredStyle: .actionSheet)
        
        for mapType in mapTypes {
            ac.addAction(UIAlertAction(title: "\(mapType)", style: .default, handler: changeMapType))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    @objc func changeMapType(action: UIAlertAction) {
        guard let action = action.title else { return }
        
        var mkmaptype: MKMapType
        
        switch(action) {
        case ".standard":
            mkmaptype = .standard
        case ".mutedStandard":
            mkmaptype = .mutedStandard
        case ".satellite":
            mkmaptype = .satellite
        case ".satelliteFlyover":
            mkmaptype = .satelliteFlyover
        case ".hybrid":
            mkmaptype = .hybrid
        case ".hybridFlyover":
            mkmaptype = .hybridFlyover
        default:
            mkmaptype = .standard
        }
        
        mapView.mapType = mkmaptype
    }
}

