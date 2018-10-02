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

struct CaptionInfo : Codable {
    var name : String
    var photos : [[String:String]]
}

typealias Parks = [Info]
typealias ParksAndCaptions = [CaptionInfo]

class Model {
    //let allParks : Parks
    fileprivate let allParksWithCapitons : ParksAndCaptions
    
    static let sharedInstance = Model()
    
    fileprivate init () {
        let mainBundle = Bundle.main
        //let solutionURL = mainBundle.url(forResource: "Parks", withExtension: "plist")
        
        let newSolutionURL = mainBundle.url(forResource: "StateParks", withExtension: "plist")
        
        do {
            /*
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allParks = try decoder.decode(Parks.self, from: data)
            */
            let captionData = try Data(contentsOf: newSolutionURL!)
            let newDecoder = PropertyListDecoder()
            allParksWithCapitons = try newDecoder.decode(ParksAndCaptions.self, from: captionData)

        } catch {
            print(error)
            //allParks = []
            allParksWithCapitons = []
        }
    }
    
    func lengthOfParks() -> Int {
        return allParksWithCapitons.count
    }
    
    func park(_ index : Int) -> String {
        return allParksWithCapitons[index].name
    }
    
    func parkInfoLength(_ index : Int) -> Int {
        return allParksWithCapitons[index].photos.count
    }
    
    func parkCaption(_ index : Int, _ parkImageIndex : Int, _ parkImageName : String) -> String {
        return allParksWithCapitons[index].photos[parkImageIndex]["caption"]!
    }
}
