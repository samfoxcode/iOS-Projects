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
    
    init(title:String?, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PlotBuildingDelegate, OptionsDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let mapModel = CampusModel.sharedInstance
    let locationManager = CLLocationManager()
    let kSpanLatitudeDelta = 0.027
    let kSpanLongitudeDelta = 0.027
    
    let kSpanLatitudeDeltaZoom = 0.002
    let kSpanLongitudeDeltaZoom = 0.002
    
    var allAnnotations = [MKAnnotation]()
    var allBuildings = false
    var userLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate  = CLLocationCoordinate2D(latitude: 40.8012, longitude: -77.859909)
        let span = MKCoordinateSpan(latitudeDelta: kSpanLatitudeDelta, longitudeDelta: kSpanLongitudeDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        locationManager.delegate = self
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
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func plot(building: String, changeRegion : Bool = true) {
        let coordinate = mapModel.buildingLocation(building)?.coordinate
        let title = building
        
        let span = MKCoordinateSpan(latitudeDelta: kSpanLatitudeDeltaZoom, longitudeDelta: kSpanLongitudeDeltaZoom)
        
        if changeRegion {
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            self.mapView.setRegion(region, animated: true)
        }
        let campusBuilding = CampusBuilding(title: title, coordinate: coordinate!)
        allAnnotations.append(campusBuilding)
        self.mapView.addAnnotation(campusBuilding)
        /*
        UIView.animate(withDuration: 2, delay: 1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            self.mapView.setRegion(region, animated: true)
        }, completion: {(finished) in
            self.mapView.addAnnotation(campusBuilding)
        })
        */
    }

    
    func userLocation(_ toggle : Bool){
        userLocation = toggle
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
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BuildingList":
            let navController = segue.destination as! UINavigationController
            let buildingListViewController = navController.topViewController as! TableViewController
            buildingListViewController.delegate = self
        case "OptionsSegue":
            let navController = segue.destination as! UINavigationController
            let optionsController = navController.topViewController as! OptionsViewController
            optionsController.delegate = self
            optionsController.configure(userLocation: userLocation, allBuildings: allBuildings)
        default:
            assert(false, "Unhandled Segue")
        }
    }

}

