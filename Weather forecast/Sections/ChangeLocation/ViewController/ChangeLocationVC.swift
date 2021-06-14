//
//  ChangeLocation.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//
import UIKit
import MapKit

protocol SearchVCDelegate: AnyObject {
    func reloadTableWithNewData()
}
class ChangeLocationVC: WFBaseController {
    
    weak var delegate: SearchVCDelegate?
    @IBOutlet weak var mapView: MKMapView!
    var viewModel: ChangeViewModel?
    var currentLocation: Bool?
    fileprivate var searchController: UISearchController!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangeViewModel()
        self.mapViewProprtySet()
        self.setNavigation()
        self.navigationItem.title = "Select Location"
    }
}

extension ChangeLocationVC {
    func setNavigation() {
        let cancelItem = UIBarButtonItem(image: UIImage(named: "cancel"), style: .done, target: self, action: #selector(cancelClicked))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        let addButton = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .done, target: self, action: #selector(doneClicked))
        self.navigationItem.rightBarButtonItem = addButton
        
   
        let search = UIBarButtonItem(image: UIImage(named: "search"), style: .done, target: self, action: #selector(searchClicked))
        self.navigationItem.rightBarButtonItems?.append(search)
    }
    
    @objc func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneClicked() {
        if let model = viewModel {
            model.saveDataToDatabase()
            self.dismiss(animated: true, completion: {
                self.delegate?.reloadTableWithNewData()
            })
        }
    }
    
    @objc func searchClicked() {
        if WFReachability.isNetworkAvaible() {
            if searchController == nil {
                searchController = UISearchController(searchResultsController: nil)
            }
            searchController.hidesNavigationBarDuringPresentation = false
            self.searchController.searchBar.delegate = self
            present(searchController, animated: true, completion: nil)
        } else {
            self.showNoInternetConnection()
        }
       
    }
    
}

extension ChangeLocationVC: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        let searchText =  searchBar.text ?? ""
        currentLocation = false
        if searchText != "" {
            WFLocationManager.shared.changeWithLocationClicked(searchText: searchText, onSuccess: {(cordinates) in
                searchBar.text = ""
                if cordinates?.error != nil {
                    self.showAlert(title: "Alert", message: cordinates?.error ?? "")
                } else {
                    if let latitude = cordinates?.latitude, let longitude = cordinates?.longitude {
                        self.addLongPressedLocation(lat: latitude, lng: longitude)
                    }
                }
            })
        }
    }
}

extension ChangeLocationVC {
    func mapViewProprtySet() {
        if let location = WFStore.shared.currentLocation, let lat = location.latitude, let lng = location.longitude {
            currentLocation = true
            mapView.delegate = self
            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
            mapView.setCenter(center, animated: true)
            let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
            mapView.region = myRegion
            let myPin: MKPointAnnotation = MKPointAnnotation()
            myPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            myPin.title = WFStore.shared.currentLocation?.city ?? ""
            myPin.title = WFStore.shared.currentLocation?.zip ?? ""
            mapView.addAnnotation(myPin)
            
            let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
            myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
            mapView.addGestureRecognizer(myLongPress)
        }
    }
    
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        if WFReachability.isNetworkAvaible() {
            if sender.state != UIGestureRecognizer.State.began {
                return
            }
            currentLocation = false
            let location = sender.location(in: mapView)
            let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
            let myPin: MKPointAnnotation = MKPointAnnotation()
            myPin.coordinate = myCoordinate
            let locationCord = CLLocation(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude)
            DispatchQueue.global(qos: .userInitiated).async {
                WFLocationManager.shared.getRevGeoCodeLocation(location: locationCord, onSuccess: {(info) in
                    DispatchQueue.main.async {
                        print(info)
                        myPin.title = info.city
                        myPin.subtitle = info.zip
                        if let model = self.viewModel {
                            model.pinnedLocationSaveinDB(location: info)
                        }
                    }
                })
            }
            mapView.addAnnotation(myPin)
        } else {
            self.showNoInternetConnection()
        }
        
    }
    
    
    func addLongPressedLocation(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate.latitude = lat
        myPin.coordinate.longitude = lng
        let locationCord = CLLocation(latitude: lat, longitude: lng)
        DispatchQueue.global(qos: .userInitiated).async {
            WFLocationManager.shared.getRevGeoCodeLocation(location: locationCord, onSuccess: {(info) in
                DispatchQueue.main.async {
                    print(info)
                    myPin.title = info.city
                    myPin.subtitle = info.zip
                    if let model = self.viewModel {
                        model.pinnedLocationSaveinDB(location: info)
                    }
                }
            })
        }
        mapView.centerCoordinate = myPin.coordinate
        mapView.addAnnotation(myPin)
    }
    
}

extension ChangeLocationVC: MKMapViewDelegate {
    
    // Delegate method called when addAnnotation is done.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let myPinIdentifier = "PinAnnotationIdentifier"
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        myPinView.animatesDrop = true
        if currentLocation == true {
            myPinView.pinTintColor = .green
        } else {
            myPinView.pinTintColor = .red
        }
        myPinView.canShowCallout = true
        myPinView.annotation = annotation
     
        return myPinView
    }
}
