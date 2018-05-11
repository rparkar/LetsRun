//
//  RunViewController.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-01.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
    }

    func addLastRunToMap() -> MKPolyline? {
        
        guard let lastRun = Run.getAllRuns()?.first else {return nil}
        avgPaceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(places: 2)) mi"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapPreviousRun(locations: lastRun.locations), animated: true)
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    func setUpView() {
        if let overLay = addLastRunToMap() {
            
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.add(overLay)
            showLastRunView()
        } else {
            closeLastRunView()
            centerMapToUserLocation()
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func centerLocationPressed(_ sender: Any) {
        centerMapToUserLocation()
    }
    
    func centerMapToUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 700, 700)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapPreviousRun(locations: List<Location>) -> MKCoordinateRegion {
        
        guard let initialLocation  = locations.first else {return MKCoordinateRegion()}
        var minLat = initialLocation.latitude
        var minLong = initialLocation.longitude
        
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
            
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLong - minLong) * 1.5))
    }
    
    @IBAction func closeLastRunPressed(_ sender: Any) {
        closeLastRunView()
        centerMapToUserLocation()
    }
}



extension RunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
           // mapView.userTrackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay as! MKPolyline
        let renderer = MKPolylineRenderer (polyline: polyLine)
        renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        renderer.lineWidth = 5
        return renderer
        
    }
}
