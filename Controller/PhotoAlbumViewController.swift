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
    let stackView = UIStackView()
    let newCollectButton = UIButton()
    //let collection = UICollectionView()
    //let flowLayout = UICollectionFlowLayout()
    var dataController:DataController!
    var pin = MKPointAnnotation()
    var realPin: Pin?
    var photos: [Photo?] = []
    
    override func viewDidLoad() {
        //TODO: verify photos are even avail
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setMapView()
        setCollectionView()
        setNewCollectionButton()
    }
    
    func setMapView() {
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = 0
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        span.latitudeDelta = 1
        span.longitudeDelta = 1
        region.center = pin.coordinate
        region.span = span
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        view.addSubview(mapView)
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
    }
    
    func setNewCollectionButton() {
        newCollectButton.setTitle("New Collection", for: UIControl.State.normal)
        newCollectButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        newCollectButton.backgroundColor = UIColor.white
        newCollectButton.clipsToBounds = true
        newCollectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCollectButton)
        newCollectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newCollectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newCollectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setCollectionView() {
        //TODO: fetch photos, delete ability, new collection
    }

}
