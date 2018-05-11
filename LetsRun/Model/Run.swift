//
//  Run.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-05.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    
    @objc dynamic public private (set) var id = ""
    @objc dynamic public private (set) var pace = 0
    @objc dynamic public private (set) var distance = 0.0
    @objc dynamic public private (set) var duration = 0
    @objc dynamic public private (set) var date = NSDate()
    
    public private (set) var locations = List<Location>()
    
    //primary key
    override class func primaryKey() -> String {
        return "id"
    }
    
    //indexed properties
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
        
    }
    
    static func addRunToRealmDB(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        
        REALM_QUE.sync {
            
            let run = Run(pace: pace, distance: distance, duration: duration, locations: locations)
            
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            } catch {
                debugPrint("error adding to realm ")
            }
        }

    }
    
    static func getAllRuns() -> Results<Run>? {
        
        do {
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
            
        } catch {
            return nil
        }
    }
    
    //FUTURE UPDATE: To get Run by id
    static func getRun(byId id: String) -> Run? {
        do {
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            return realm.object(ofType: Run.self, forPrimaryKey: id)
        } catch {
            return nil
        }
    }
    
    
}
