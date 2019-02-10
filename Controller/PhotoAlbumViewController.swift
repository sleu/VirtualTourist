//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/14/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    let mapView = MKMapView()
    let newCollectButton = UIButton()
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    var pin = MKPointAnnotation()
    var realPin: Pin?
    var photos: [Photo?] = []
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", realPin!)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        mapView.delegate = self
        view.backgroundColor = UIColor.blue
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupFetchedResultsController()
        setMapView()
        setFlowLayOutView()
        setCollectionView()
        setNewCollectionButton()
    }
    
    @objc func getNewPhotos() {
        let totalPages = Int((realPin?.pages.description)!)
        if totalPages! <= 1 {
            displayNotification("All Images Displayed")
            return
        }
        
        
        collectionView.reloadData()
    }
    
    func displayNotification(_ error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
