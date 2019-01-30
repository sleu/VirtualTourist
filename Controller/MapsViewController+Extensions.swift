//
//  MapsViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/14/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            print("annotation not found")
            return
        }
        mapView.deselectAnnotation(annotation, animated: true)
        let pin = view.annotation
        let newVC = PhotoAlbumViewController()
        newVC.dataController = dataController
        newVC.pin = pin as! MKPointAnnotation
        let title = annotation.title
        guard let indexTitle = Int(title!!) else {
            print("NO TITLE")
            return
        }
        newVC.realPin = loadPin(title: indexTitle)!
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func loadPin(title: Int) -> Pin? {
        let pin = fetchedResultsController.fetchedObjects?[title]
        return pin
    }
}
