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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, PlotBuildingDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let mapModel = CampusModel.sharedInstance
    let locationManager = CLLocationManager()
    let kSpanLatitudeDelta = 0.027
    let kSpanLongitudeDelta = 0.027
    
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
    
    func plot(building: String) {
        let coordinate = mapModel.buildingLocation(building)?.coordinate
        let title = building
        let campusBuilding = CampusBuilding(title: title, coordinate: coordinate!)
        
        UIView.animate(withDuration: 1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: coordinate!, span: span)
            self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(campusBuilding)
        })
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BuildingList":
            let navController = segue.destination as! UINavigationController
            let buildingListViewController = navController.topViewController as! TableViewController
            buildingListViewController.delegate = self
            
        default:
            assert(false, "Unhandled Segue")
        }
    }

}

