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

extension String {
    func firstLetter() -> String? {
        let substring =  self[self.startIndex...self.startIndex]
        return String(substring)
    }
}
    
class CampusModel {
    
    fileprivate let allBuildings : Buildings
    fileprivate let buildingByInitial: [String:[Building]]
    fileprivate let buildingKeys : [String]
    
    static let sharedInstance = CampusModel()
    
    fileprivate init() {
        
        
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "buildings", withExtension: "plist")
        
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allBuildings = try decoder.decode(Buildings.self, from: data)
            
            // create dictionary mapping first letter to states
            var  _buildingsByInitial = [String:[Building]]()
            for building in allBuildings {
                let letter = building.name.firstLetter()!
                if  _buildingsByInitial[letter]?.append(building) == nil {
                    _buildingsByInitial[letter] = [building]
                }
            }
            buildingByInitial = _buildingsByInitial
            buildingKeys = buildingByInitial.keys.sorted()
            
        } catch {
            print(error)
            allBuildings = []
            buildingByInitial = [:]
            buildingKeys = []
        }
        
    }
    
    var numberOfKeys : Int {return buildingKeys.count}
    var buildingIndexTitles : [String] {return buildingKeys}
    
    func buildingIndexTitle(_ index:Int) -> String {
        return buildingKeys[index]
    }
    
    func numberOfBuildingsForKey(_ index:Int) -> Int {
        let key = buildingKeys[index]
        let buildings = buildingByInitial[key]!
        return buildings.count
    }
    
    func buildingName(at indexPath:IndexPath) -> String {
        let key = buildingKeys[indexPath.section]
        let buildings = buildingByInitial[key]!
        let building = buildings[indexPath.row]
        return building.name
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
                let latitude = allBuildings[i].latitude
                let longitude = allBuildings[i].longitude
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
}

