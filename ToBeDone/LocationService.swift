//
//  LocationService.swift
//  ToBeDone
//
//  Created by 周星 on 11/9/16.
//  Copyright © 2016 周星. All rights reserved.
//
//
// Public Interface:
// ==============
// getCurrentPlaceName( : placeNameDisplayMode!, : getPlaceHandler?)
// handler will pass generatedPlaceName as para.



import MapKit
import CoreLocation
import Foundation

enum placeNameDisplayMode {
    case concise
    case verbose
}

class LocationService : NSObject , CLLocationManagerDelegate{
    
    
    static let sharedInstance = LocationService()
    
    var locationManager : CLLocationManager! = CLLocationManager()
     var lat : Double = 0.0
     var lng : Double = 0.0
     var place : String = ""
    var mode: placeNameDisplayMode! = .concise
    
    typealias getPlaceHandler = (String?) -> ()
    typealias getCLLocationHandler = (CLLocation?) -> ()
     var getPlace : getPlaceHandler?
      var getLngLat : getCLLocationHandler?
    var reverseGeoCodeRequest = true
    
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    func getCurrentCLLocation(completionHandler: getCLLocationHandler?) {
        
        reverseGeoCodeRequest = false
        getLngLat = completionHandler
        if (CLLocationManager.locationServicesEnabled()){
            
            locationManager.startUpdatingLocation()
            print("start updating location ")
            
        }  else {
            CLLocationManager.authorizationStatus()
            print(" location service disabled")
        }
        
    }
    func getCurrentPlaceName(placeNameDisplayMode: placeNameDisplayMode!,  completionHandler: getPlaceHandler?)
    {
        
        getPlace = completionHandler
        mode = placeNameDisplayMode
        reverseGeoCodeRequest = true
        
        if (CLLocationManager.locationServicesEnabled()){
            
            locationManager.startUpdatingLocation()
            print("start updating location ")
            
        }  else {
            CLLocationManager.authorizationStatus()
            print(" location service disabled")
        }

        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let currLocation = locations.last!
        if currLocation.horizontalAccuracy > 0 {
            lat = currLocation.coordinate.latitude
            lng = currLocation.coordinate.longitude
            
            
        }
        if (reverseGeoCodeRequest == true)  {
            reverseGeoCode(location: currLocation)
        }
        else {
            guard let location = locations.last else {
                assert(true, "error!, no location object obtained")
                return
            }
            if let handler = getLngLat {
                handler(location)
            }
        }
        
        locationManager.stopUpdatingLocation()
        
    }
    
    private func reverseGeoCode (location : CLLocation) {
        let coder = CLGeocoder()
        weak var weakSelf = self
        coder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
        
//            guard error != nil else {
//                return
//            }
//            guard let placemark = placemark?.first else {
//                return
//            }
            if let placemark = placemark?.first {
            let subThoroughfare = placemark.subThoroughfare!
            let  thoroughfare   = placemark.thoroughfare!
            let  name            = placemark.name!
            let  subLocality   = placemark.subLocality!
            let locality      = placemark.locality!
            let state           = placemark.administrativeArea!
            let postalCode      = placemark.postalCode!
            
            if let _weakSelf = weakSelf {
               
                var locationName : String!
                if (_weakSelf.mode == .concise) {
                    locationName =  name + " " +
                    locality + " " +
                    state + ", " +
                    postalCode

                }
                
                if (_weakSelf.mode == .verbose) {
                     locationName  = subThoroughfare +
                        thoroughfare + " " +
                        subLocality + " " +
                        locality + " " +
                        state + ", " +
                    postalCode
                }
               
                
                _weakSelf.place = locationName
                if let handler = _weakSelf.getPlace {
                    
                    handler(locationName)
                }
                
            }
                
            }
        }
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print(error ?? "the error is NULL")
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        self.locationManager.stopUpdatingLocation()
        
        print("cannot get location or location service unabled")
    }

    
    
}

