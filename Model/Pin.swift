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
        } else {
            fatalError("Entity Not Found")
        }
    }
}
