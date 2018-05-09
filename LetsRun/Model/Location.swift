//
//  Location.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-08.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation
import RealmSwift

class Location : Object {
    
    @objc dynamic public private (set) var latitude = 0.0
    @objc dynamic public private (set) var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
