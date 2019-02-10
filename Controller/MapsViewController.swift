//
//  MapsViewController.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/14/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData


class MapsViewController: UIViewController {
    
    let mapView = MKMapView()
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("fetch failed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.setMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
        self.loadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("loadData fetch failed")
        }
        
        guard let fetchedObj = fetchedResultsController.fetchedObjects else {
            print("unable to fetch objects")
            return
        }
        
        var annotations = [MKPointAnnotation]()
        for (index, pin) in fetchedObj.enumerated() {
            let annotation = MKPointAnnotation()
            let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.coordinate = coordinates
            annotation.title = "\(index)"
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    @objc func createPin(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            print("Begin")
            let loc = sender.location(in: mapView)
            let coordinate = mapView.convert(loc, toCoordinateFrom: mapView)
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.coordinate = coordinate
            if let fetchedObj = fetchedResultsController.fetchedObjects {
                pinAnnotation.title = "\(fetchedObj.count)"
            }
            mapView.addAnnotation(pinAnnotation)
            let pin = Pin(lat: coordinate.latitude, long: coordinate.longitude, context: dataController.viewContext)
            pin.getPhotos(context: dataController.viewContext) //Load photos!!!
            
            do {
                try dataController.viewContext.save()
                try fetchedResultsController.performFetch()
            } catch {
                print(error.localizedDescription)
            }
            print("pin complete")
        }
    }
}
