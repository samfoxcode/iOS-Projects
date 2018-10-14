//
//  MapModel.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/13/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import Foundation
import MapKit

struct Building : Codable {
    let name : String
    let opp_bldg_code : Int
    let year_constructed : Int
    let latitude : Double
    let longitude : Double
    let photo : String
}

typealias Buildings = [Building]

class CampusModel {
    
    fileprivate let allBuildings : Buildings
    
    static let sharedInstance = CampusModel()
    
    fileprivate init() {
        
        
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "buildings", withExtension: "plist")
        
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allBuildings = try decoder.decode(Buildings.self, from: data)
        } catch {
            print(error)
            allBuildings = []
        }
        
    }
    
    func numberOfBuildings() -> Int {
        return allBuildings.count
    }
    func nameOfBuilding(_ index : Int) -> String {
        return allBuildings[index].name
    }
    func photoNameBuilding(_ index : Int) -> String {
        return allBuildings[index].photo
    }
    func buildingLocation(_ name : String) -> CLLocation? {
        for i in 0..<allBuildings.count {
            if allBuildings[i].name == name {
                print("hit")
                let latitude = allBuildings[i].latitude
                let longitude = allBuildings[i].longitude
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
}

