//
//  PhotoAlbumViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/24/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension PhotoAlbumViewController: MKMapViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
