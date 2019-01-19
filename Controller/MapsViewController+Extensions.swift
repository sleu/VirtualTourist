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
        print("changevc")
        //TODO: load photo album
        let newVC = PhotoAlbumViewController()
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
}
