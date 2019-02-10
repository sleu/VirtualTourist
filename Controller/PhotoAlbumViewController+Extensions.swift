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

extension PhotoAlbumViewController: MKMapViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController.sections?[section] {
            print("number of items: \(sectionInfo.numberOfObjects)")
            if sectionInfo.numberOfObjects == 0 {
                displayNotification("No Images Found")
            }
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let pphoto = fetchedResultsController.object(at: indexPath)
        cell.backgroundView = UIImageView(image: UIImage(data: pphoto.imageData!))
        cell.activityIndicator.stopAnimating()
        cell.activityIndicator.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        //This is for delete phot
        print("Selected:\(indexPath)")
    }
}
