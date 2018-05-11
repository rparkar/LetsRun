//
//  OnRunViewController.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-02.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class OnRunViewController: LocationViewController {

    //outlets
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var sliderOutlineImageView: UIImageView!
    @IBOutlet weak var sliderEndButtonImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var averagePaceLabel: UILabel!
    //variables
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    var timer = Timer()
    var countTimer = 0
    var pace = 0
    var coordinateLocations = List<Location>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(sender:)))
        sliderEndButtonImageView.addGestureRecognizer(swipeGesture)
        sliderEndButtonImageView.isUserInteractionEnabled = true
        
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
        
    }
    
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func startTimer() {
        durationLabel.text = countTimer.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter() {
        countTimer += 1
        durationLabel.text = countTimer.formatTimeDurationToString()
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
        
    }
    
    func pauseRun(){
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseButton.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
        startLocation = nil
        lastLocation = nil
    }
    
    func stopRun(){
        manager?.stopUpdatingLocation()
        //add objects to realm DB
        Run.addRunToRealmDB(pace: pace, distance: runDistance, duration: countTimer, locations: coordinateLocations)
    }


    @objc func endRunSwipe(sender: UIPanGestureRecognizer) {
        
        let minAdjust: CGFloat = 80
        let maxAjust: CGFloat = 130
        
        if let sliderView = sender.view {
            let translation = sender.translation(in: self.view)
            if sender.state == UIGestureRecognizerState.began || sender.state == UIGestureRecognizerState.changed {
                
                if sliderView.center.x >= (sliderOutlineImageView.center.x - minAdjust) && sliderView.center.x <= (sliderOutlineImageView.center.x + maxAjust) {
                    
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (sliderOutlineImageView.center.x + maxAjust) {
                    sliderView.center.x = sliderOutlineImageView.center.x + maxAjust
                    stopRun()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = sliderOutlineImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizerState.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderOutlineImageView.center.x - minAdjust
                }
            }
        }
        
    }

}

extension OnRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
            
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLabel.text = "\(runDistance.metersToMiles(places: 2))"
            
            if countTimer > 0 && runDistance > 0 {
                averagePaceLabel.text = calculatePace(time: countTimer, miles: runDistance.metersToMiles(places: 2))
            }
        }
        
        lastLocation = locations.last
    }
}
