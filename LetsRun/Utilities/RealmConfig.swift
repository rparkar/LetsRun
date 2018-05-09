//
//  RealmConfig.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-08.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion:0,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
                    //nothing to do
                    //Realm will detect new properties and remove old ones
                }
        })
      return config
    }
}
