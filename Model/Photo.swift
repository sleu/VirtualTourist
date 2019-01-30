//
//  Photo.swift
//  VirtualTourist
//
//  Created by Sean Leu on 1/23/19.
//  Copyright © 2019 Sean Leu. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    convenience init(url: String, id: String, pin: Pin, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.id = id
            self.pin = pin
            
            downloadPhoto()
        } else {
            fatalError("Entity Not Found")
        }
    }
    
    func downloadPhoto() {
        guard let imageURL = URL(string: self.url!) else {
            print("photo url is nil")
            return
        }
        if let imageData = try? Data(contentsOf: imageURL) {
            self.imageData = imageData //TODO: possibly change here for image data format
            print("photodownloaded")
        } else {
            print("Image does not exist at \(imageURL)")
        }
    }
}