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
    }
    
    func setMapView() {
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 0
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        let pinPress = UILongPressGestureRecognizer(target: self, action: #selector(createPin(_:)))
        mapView.addGestureRecognizer(pinPress)
        view.addSubview(mapView)
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
        for p in fetchedObj {
            let annotation = MKPointAnnotation()
            let coordinates = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)
            annotation.coordinate = coordinates
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    @objc func createPin(_ sender: UIGestureRecognizer) {
        //TODO: Drop a pin and record the pin
        if sender.state == .began {
            print("Begin")
            let loc = sender.location(in: mapView)
            let coordinate = mapView.convert(loc, toCoordinateFrom: mapView)
            let pinAnnotation = MKPointAnnotation()
            pinAnnotation.coordinate = coordinate
            mapView.addAnnotation(pinAnnotation)
            _ = Pin(lat: coordinate.latitude, long: coordinate.longitude, context: dataController.viewContext)
            do {
                try dataController.viewContext.save()
                try fetchedResultsController.performFetch()
            } catch {
                print(error.localizedDescription)
            }
            //find photos for pin
            //save
        }
    }
}
