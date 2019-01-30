//
//  Pin.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/19/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import CoreData

extension Pin {
    
    convenience init(lat: Double, long: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = lat
            self.longitude = long
            self.pages = 1
        } else {
            fatalError("Entity Not Found")
        }
    }
    
    func getPhotos(context: NSManagedObjectContext) { //TODO: how to reuse for new round of pics
        FlickrClient.shared.searchBy(latitude: latitude, longitude: longitude, pages: Int(pages)) { (photos, pages, errorMessage) in
            DispatchQueue.main.async {
                print("getphotos")
                guard errorMessage == nil else {
                    print("error found")
                    return
                }
                self.pages = Int16(pages)
                for p in photos! where p["url_m"] != nil {
                    _ = Photo(url: p["url_m"] as! String, id: p["id"] as! String ,pin: self, context: context)
                    print("Creatingphoto")
                }
                print("photos completed")
            }
        }
    }
}
