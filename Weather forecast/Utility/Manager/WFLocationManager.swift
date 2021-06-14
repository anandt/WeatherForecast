//
//  WFLocationManager.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import MapKit
import CoreLocation

class WFLocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = WFLocationManager()
    let locationManager : CLLocationManager
    var locationInfoCallBack: ((_ info:LocationInformation)->())!
    
    // MARK: - Search
    fileprivate var localSearchRequest: MKLocalSearch.Request!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearch.Response!

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        super.init()
        locationManager.delegate = self
    }
    
    
    func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->())) {
        self.locationInfoCallBack = locationInfoCallBack
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func initilize() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationAuthorizationStatus() -> Bool {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch locationAuthorizationStatus {
        case .restricted, .denied, .notDetermined :
            return false
        default:
            return true
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                break
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                break
            case .restricted:
                // restricted by e.g. parental controls. User can't enable Location Services
                break
            case .denied:
                // user denied your app access to Location Services, but can grant access from Settings.app
                break
            default:
                break
            }
        }
    }
  

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        print(mostRecentLocation)
        
        self.getRevGeoCodeLocation(location: mostRecentLocation, onSuccess: {(location) in
            self.locationInfoCallBack(location)
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
    
    func getRevGeoCodeLocation(location: CLLocation, onSuccess: @escaping (LocationInformation) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
                let state = placemark.administrativeArea,
                let name = placemark.name,
                let zip = placemark.postalCode,
                let locationName = placemark.name,
                let country = placemark.country {
                let locInformation = LocationInformation()
                locInformation.latitude = location.coordinate.latitude
                locInformation.longitude = location.coordinate.longitude
                locInformation.city  = city
                locInformation.state  = state
                locInformation.areaName  = name
                locInformation.zip = zip
                locInformation.address =  locationName
                locInformation.country  = country
                onSuccess(locInformation)
            }
        }
    }
}

class LocationInformation {
    var areaName:String?
    var city:String?
    var address:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var zip:String?
    var state :String?
    var country:String?
    init(city:String? = "",address:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0),zip:String? = "",state:String? = "",country:String? = "",area:String? = "") {
        self.city = city
        self.areaName = area
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.zip        = zip
        self.state = state
        self.country = country
    }
}

class MKCoordinates {
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var error: String?
    init(latitude:CLLocationDegrees? = Double(0.0), longitude:CLLocationDegrees? = Double(0.0), error: String?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


extension WFLocationManager {
    func changeWithLocationClicked(searchText: String, onSuccess: @escaping (MKCoordinates?) -> Void) {
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchText
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [unowned self] (localSearchResponse, error) -> Void in
            var dataIs : MKCoordinates?
            if localSearchResponse == nil {
                dataIs = MKCoordinates(latitude: nil, longitude: nil, error: error.debugDescription)
            } else {
                dataIs = MKCoordinates(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude, error: error.debugDescription)
            }
            onSuccess(dataIs)
        }
    }
}
