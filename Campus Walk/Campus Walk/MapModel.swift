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
    
    fileprivate var allBuildings : Buildings
    fileprivate var buildings : Buildings
    fileprivate var buildingByInitial: [String:[Building]]
    fileprivate var buildingKeys : [String]
    
    static let sharedInstance = CampusModel()
    
    fileprivate init() {
        
        
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "buildings", withExtension: "plist")
        
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            buildings = try decoder.decode(Buildings.self, from: data)
            
            // create dictionary mapping first letter to buildings
            var  _buildingsByInitial = [String:[Building]]()
            for building in buildings {
                let letter = building.name.firstLetter()!
                if  _buildingsByInitial[letter]?.append(building) == nil {
                    _buildingsByInitial[letter] = [building]
                }
            }
            buildingByInitial = _buildingsByInitial
            buildingKeys = buildingByInitial.keys.sorted()
            
        } catch {
            print(error)
            buildings = []
            buildingByInitial = [:]
            buildingKeys = []
        }
        allBuildings = buildings
        
    }
    
    var numberOfKeys : Int {return buildingKeys.count}
    var buildingIndexTitles : [String] {return buildingKeys}
    
    func updateKeys(){
        var  _buildingsByInitial = [String:[Building]]()
        for building in buildings {
            let letter = building.name.firstLetter()!
            if  _buildingsByInitial[letter]?.append(building) == nil {
                _buildingsByInitial[letter] = [building]
            }
        }
        buildingByInitial = _buildingsByInitial
        buildingKeys = buildingByInitial.keys.sorted()
    }
    
    func buildingIndexTitle(_ index:Int) -> String {
        // create dictionary mapping first letter to buildings
        updateKeys()
        return buildingKeys[index]
    }
    
    func numberOfBuildingsForKey(_ index:Int) -> Int {
        // create dictionary mapping first letter to buildings
        updateKeys()
        let key = buildingKeys[index]
        let _buildings = buildingByInitial[key]!
        return _buildings.count
    }
    
    func buildingName(at indexPath:IndexPath) -> String {
        // create dictionary mapping first letter to buildings
        updateKeys()
        let key = buildingKeys[indexPath.section]
        let _buildings = buildingByInitial[key]!
        let building = _buildings[indexPath.row]
        return building.name
    }
    
    func numberOfBuildings() -> Int {
        return buildings.count
    }
    func nameOfBuilding(_ index : Int) -> String {
        return buildings[index].name
    }
    func photoNameBuilding(_ index : Int) -> String {
        return buildings[index].photo
    }
    func buildingLocation(_ name : String) -> CLLocation? {
        for i in 0..<buildings.count {
            if buildings[i].name == name {
                let latitude = buildings[i].latitude
                let longitude = buildings[i].longitude
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    
    func buildingPhotoName(_ name : String) -> String? {
        for i in 0..<buildings.count {
            if buildings[i].name == name {
                return buildings[i].photo
            }
        }
        return nil
    }
    
    func updateFilter(filter: (Building) -> Bool) {
        buildings = allBuildings.filter(filter)
        updateKeys()
    }
}

