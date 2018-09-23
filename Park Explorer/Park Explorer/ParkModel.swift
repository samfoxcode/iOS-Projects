//
//  ParkModel.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/23/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import Foundation

struct Info : Codable {
    var name : String
    var count : Int
}

typealias Parks = [Info]

class Model {
    let allParks : Parks
    
    init () {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "Parks", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allParks = try decoder.decode(Parks.self, from: data)
        } catch {
            print(error)
            allParks = []
        }
    }
    
    func lengthOfParks() -> Int {
        return allParks.count
    }
    
    func park(_ index : Int) -> Info {
        return allParks[index]
    }
    
    func parkInfoLength(_ index : Int) -> Int {
        return allParks[index].count
    }
    
    func parkName(_ index : Int) -> String {
        return allParks[index].name
    }
}
