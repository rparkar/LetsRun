//
//  LocationViewController.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-03.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
        
        
        // Do any additional setup after loading the view.
    }

    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }


}
