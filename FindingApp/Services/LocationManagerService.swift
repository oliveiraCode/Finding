//
//  LocationManager.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-18.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerService: NSObject, CLLocationManagerDelegate {
    
    //MARK - properties
    static let shared = LocationManagerService()
    
    private var locationManager = CLLocationManager()
    var currentLocation = CLLocation (latitude: Coordinates.latitude, longitude:Coordinates.longitude)
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        
        //stop to get current location to save battery
        locationManager.stopUpdatingLocation()
    }
    
    //MARK - set location manager values
    private override init() {
        super.init()
        
        //setting this view controller to be responsible of Managing the locations
        locationManager.delegate = self
        
        //set the best accurancy
        //WARNING - the best accurancy could consume too much battery
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //verifie if authorization status was setted
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    func getDefaultCLLocationValue(){
        currentLocation = CLLocation(latitude: Coordinates.latitude, longitude: Coordinates.longitude)
    }
    
}
