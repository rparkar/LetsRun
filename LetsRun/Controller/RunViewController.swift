//
//  RunViewController.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-01.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import MapKit

class RunViewController: LocationViewController {
    
    //outlets
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
       
        manager?.delegate = self //as? CLLocationManagerDelegate
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func centerLocationPressed(_ sender: Any) {
    }
    

}



extension RunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
