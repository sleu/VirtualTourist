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
        if fetchedResultsController.fetchedObjects?.count ?? 0 < 1 {
            displayNotification("No Photos Found")
        }
    }
    
    @objc func getNewPhotos() {
        newCollectButton.isEnabled = false
        let totalPages = Int((realPin?.pages.description)!)
        if totalPages! <= 1 {
            displayNotification("All Images Displayed")
            return
        }
        let photos = fetchedResultsController.fetchedObjects
        for p in photos! {
            dataController.viewContext.delete(p)
            print("all deleted")
        }
        do {
            try dataController.viewContext.save()
            try fetchedResultsController.performFetch()
            print("deleted saved")
        } catch {
            print(error.localizedDescription)
        }
        prepareNewPhotos()
        print("collectionvewreload")
        //collectionView.reloadData()
        print("reloadData")
        newCollectButton.isEnabled = true
    }
    
    func displayNotification(_ error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func prepareNewPhotos() {
        let totalPages = Int((realPin?.pages.description)!)
        FlickrClient.shared.searchBy(latitude: (realPin?.latitude)!, longitude: (realPin?.longitude)!, pages: totalPages!) { (photos, pages, errorMessage) in
            DispatchQueue.main.async {
                guard errorMessage == nil else {
                    print("error found")
                    return
                }
                self.realPin?.pages = Int16(pages)
                for p in photos! where p["url_m"] != nil {
                    _ = Photo(url: p["url_m"] as! String, id: p["id"] as! String ,pin: self.realPin!, context: self.dataController.viewContext)
                    print("Creatingnewphoto")
                }
                print("newphotocompleted")
                do {
                    try self.dataController.viewContext.save()
                    try self.fetchedResultsController.performFetch()
                    print("newphotosaved")
                } catch {
                    print(error.localizedDescription)
                }
            self.collectionView.reloadData()
            }
        }
    }
    func deletePhoto(_ indexPath: IndexPath) {
        dataController.viewContext.delete(fetchedResultsController.object(at: indexPath))
        do {
            try self.dataController.viewContext.save()
            try self.fetchedResultsController.performFetch()
            print("photodeletedsaved")
        } catch {
            print(error.localizedDescription)
        }
        collectionView.deleteItems(at: [indexPath])
        //collectionView.reloadData()
    }
}
