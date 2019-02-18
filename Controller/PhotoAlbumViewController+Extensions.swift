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
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        cell.backgroundView = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        let photoCell = cell as! PhotoCell
        if photo.imageData != nil {
            photoCell.backgroundView = UIImageView(image: UIImage(data: photo.imageData!))
            photoCell.activityIndicator.stopAnimating()
            photoCell.activityIndicator.isHidden = true
        } else {
            DispatchQueue.main.async {
                photo.downloadPhoto()
                photoCell.backgroundView = UIImageView(image: UIImage(data: photo.imageData!))
                photoCell.activityIndicator.stopAnimating()
                photoCell.activityIndicator.isHidden = true
            }
            
            DispatchQueue.global(qos: .background).async {
                if self.dataController.viewContext.hasChanges {
                    do {
                        try self.dataController.viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let alert = UIAlertController(title: "Delete?", message: "Delete photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in self.deletePhoto(indexPath)}))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        self.present(alert, animated: true)
        print("Selected:\(indexPath)")
    }
}
