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
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lastRunView: UIView!
    @IBOutlet weak var closeViewButton: UIButton!
    @IBOutlet weak var lastRunStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getLastRun() {
        guard let lastRun = Run.getAllRuns()?.first else {
            closeLastRunView()
            return}
        
        showLastRunView()
        avgPaceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(places: 2)) mi"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        
    }
    
    func closeLastRunView() {
        
        lastRunView.isHidden = true
        lastRunStack.isHidden = true
        closeViewButton.isHidden = true
        
    }
    
    func showLastRunView() {
        lastRunView.isHidden = false
        lastRunStack.isHidden = false
        closeViewButton.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
       
        manager?.delegate = self //as? CLLocationManagerDelegate
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func centerLocationPressed(_ sender: Any) {
    }
    
    
    @IBAction func closeLastRunPressed(_ sender: Any) {
        closeLastRunView()
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
