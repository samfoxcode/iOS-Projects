//
//  ViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/13/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import MapKit

class CampusBuilding : NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title : String?
    let favorite : Bool?
    init(title:String?, coordinate:CLLocationCoordinate2D, favorite:Bool) {
        self.title = title
        self.coordinate = coordinate
        self.favorite = favorite
    }
}

class FavoriteBuilding : NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title : String?
    let favorite : Bool?
    init(title:String?, coordinate:CLLocationCoordinate2D, favorite:Bool) {
        self.title = title
        self.coordinate = coordinate
        self.favorite = favorite
    }
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PlotBuildingDelegate, OptionsDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navBar: UINavigationItem!
    
    let mapModel = CampusModel.sharedInstance
    let locationManager = CLLocationManager()
    let userMapLocation = MKUserLocation()
    let kSpanLatitudeDelta = 0.027
    let kSpanLongitudeDelta = 0.027
    
    let kSpanLatitudeDeltaZoom = 0.002
    let kSpanLongitudeDeltaZoom = 0.002
    
    var allAnnotations = [MKAnnotation]()
    var allFavorites = [MKAnnotation]()
    var allBuildings = false
    var userLocation = false
    var mapTypeIndex = 0
    var favorites = false
    var namesOfFavorites = [String]()
    var allAnnotationsNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate  = CLLocationCoordinate2D(latitude: 40.8012, longitude: -77.859909)
        let span = MKCoordinateSpan(latitudeDelta: kSpanLatitudeDelta, longitudeDelta: kSpanLongitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        locationManager.delegate = self
        
        let trackButton = MKUserTrackingBarButtonItem(mapView: self.mapView)
        navBar.leftBarButtonItem = trackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            mapView.showsUserLocation = false
            userLocation = false
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
            userLocation = true
        default:
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if userLocation {
            mapView.userTrackingMode = .followWithHeading
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is CampusBuilding:
            return annotationView(forCampusBuilding: annotation as! CampusBuilding)
        case is FavoriteBuilding:
            return annotationView(forFavoriteBuilding: annotation as! FavoriteBuilding)
        default:
            return nil
        }
    }
    
    func annotationView(forCampusBuilding campusBuilding:CampusBuilding) -> MKAnnotationView {
        let identifier = "BuildingPin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: campusBuilding, reuseIdentifier: identifier)
            view.pinTintColor = MKPinAnnotationView.redPinColor()
            view.animatesDrop = true
            view.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            button.setTitle("X", for: .normal)
            button.setImage(UIImage(named: "delete"), for: .normal)
            view.rightCalloutAccessoryView = button
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let name = view.annotation?.title
        if namesOfFavorites.contains(name!!){
            let index = namesOfFavorites.firstIndex(of: name!!)
            namesOfFavorites.remove(at: index!)
            allFavorites.remove(at: index!)
        }
        if allAnnotationsNames.contains(name!!) {
            let index = allAnnotationsNames.firstIndex(of: name!!)
            allAnnotationsNames.remove(at: index!)
            allAnnotations.remove(at: index!)
        }
        mapView.removeAnnotation(view.annotation!)
    }
    
    func plot(building: String, changeRegion : Bool = true) {
        if allAnnotationsNames.contains(building) {
            return
        }
        let coordinate = mapModel.buildingLocation(building)?.coordinate
        let title = building
        
        let span = MKCoordinateSpan(latitudeDelta: kSpanLatitudeDeltaZoom, longitudeDelta: kSpanLongitudeDeltaZoom)
        
        if changeRegion {
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            self.mapView.setRegion(region, animated: true)
        }
        let campusBuilding = CampusBuilding(title: title, coordinate: coordinate!, favorite: false)
        allAnnotations.append(campusBuilding)
        allAnnotationsNames.append(building)
        self.mapView.addAnnotation(campusBuilding)
    }
    
    func annotationView(forFavoriteBuilding favoriteBuilding:FavoriteBuilding) -> MKAnnotationView {
        let identifier = "BuildingFavoritePin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: favoriteBuilding, reuseIdentifier: identifier)
            view.pinTintColor = MKPinAnnotationView.greenPinColor()
            view.animatesDrop = true
            view.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            button.setTitle("X", for: .normal)
            button.setImage(UIImage(named: "delete"), for: .normal)
            view.rightCalloutAccessoryView = button
        }
        
        return view
    }
    
    func plotFavorite(building: String) {
        let coordinate = mapModel.buildingLocation(building)?.coordinate
        let title = building
        
        let campusBuilding = FavoriteBuilding(title: title, coordinate: coordinate!, favorite: true)
        allFavorites.append(campusBuilding)
        self.mapView.addAnnotation(campusBuilding)
    }

    
    func userLocation(_ toggle : Bool){
        userLocation = toggle
        if CLLocationManager.locationServicesEnabled() && toggle {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.showsUserLocation = true
                mapView.userTrackingMode = .followWithHeading
                locationManager.startUpdatingHeading()
            default:
                break
                
            }
        }
        else {
            mapView.showsUserLocation = false
        }
    }
    func showAllBuildings(_ toggle : Bool){
        allBuildings = toggle
        if toggle == true {
            for i in 0..<mapModel.numberOfBuildings(){
                plot(building: mapModel.nameOfBuilding(i), changeRegion: false)
            }
        }
        else {
            mapView.removeAnnotations(allAnnotations)
        }
    }
    func mapType(_ type : Int){
        mapTypeIndex = type
        switch type{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            return
        }
    }
    func showFavorites(_ toggle: Bool) {
        favorites = toggle
        if toggle == true {
            for i in namesOfFavorites{
                plotFavorite(building: i)
            }
        }
        else {
            mapView.removeAnnotations(allFavorites)
        }
    }
    
    func favoriteBuilding(name: String) {
        
        if namesOfFavorites.contains(name) {
            let index = namesOfFavorites.firstIndex(of: name)
            namesOfFavorites.remove(at: index!)
            mapView.removeAnnotation(allFavorites[index!])
            allFavorites.remove(at: index!)
            return
        }
        let coordinate = mapModel.buildingLocation(name)?.coordinate
        let title = name
        namesOfFavorites.append(name)
        let favoriteBuilding = FavoriteBuilding(title: title, coordinate: coordinate!, favorite : true)
        allFavorites.append(favoriteBuilding)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BuildingList":
            let navController = segue.destination as! UINavigationController
            let buildingListViewController = navController.topViewController as! TableViewController
            buildingListViewController.delegate = self
            buildingListViewController.configure(namesOfFavorites)
        case "OptionsSegue":
            let navController = segue.destination as! UINavigationController
            let optionsController = navController.topViewController as! OptionsViewController
            optionsController.delegate = self
            optionsController.configure(userLocation: userLocation, allBuildings: allBuildings, mapType: mapTypeIndex, favorites: favorites)
        default:
            assert(false, "Unhandled Segue")
        }
    }

}

