//
//  PhotoAlbumViewControllerView.swift
//  VirtualTourist
//
//  Created by Sean Leu on 2/8/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension PhotoAlbumViewController {
    
    func setMapView() {
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        let mapWidth: CGFloat = view.frame.size.width
        let mapHeight: CGFloat = view.frame.size.height/4
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
        view.addSubview(mapView)
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
    }
    
    func setCollectionView() {
        let leftMargin: CGFloat = 0
        let topMargin: CGFloat = mapView.frame.size.height
        let collectWidth: CGFloat = view.frame.size.width
        let collectHeight: CGFloat = view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - mapView.frame.size.height
        let collectFrame = CGRect(x: leftMargin, y: topMargin, width: collectWidth, height: collectHeight)
        collectionView = UICollectionView(frame: collectFrame, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    func setFlowLayOutView() {
        let itemSize = (view.frame.width - 5) / 3
        let size = CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = size
        flowLayout.sectionInset = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        
    }
    
    func setNewCollectionButton() {
        newCollectButton.setTitle("New Collection", for: UIControl.State.normal)
        newCollectButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        newCollectButton.backgroundColor = UIColor.white
        newCollectButton.heightAnchor.constraint(equalToConstant: (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        newCollectButton.clipsToBounds = true
        newCollectButton.translatesAutoresizingMaskIntoConstraints = false
        newCollectButton.addTarget(self, action: #selector(getNewPhotos), for: .touchDown)
        newCollectButton.setTitleColor(UIColor.gray, for: .disabled)
        view.addSubview(newCollectButton)
        newCollectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newCollectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newCollectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
