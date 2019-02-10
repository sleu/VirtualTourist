//
//  MapViewControllerView.swift
//  VirtualTourist
//
//  Created by Sean Leu on 2/8/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapsViewController {
    
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
}
