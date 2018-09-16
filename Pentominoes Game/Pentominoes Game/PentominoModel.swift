//
//  Model.swift
//  Pentominoes
//
//  Created by John Hannan on 8/28/18.
//  Copyright (c) 2018 John Hannan. All rights reserved.
//

import Foundation

// identifies placement of a single pentomino on a board
struct Position : Codable {
    var x : Int
    var y : Int
    var isFlipped : Bool
    var rotations : Int
}

// A solution is a dictionary mapping piece names ("T", "F", etc) to positions
// All solutions are read in and maintained in an array
typealias Solution = [String:Position]
typealias Solutions = [Solution]

class Model {

    let allSolutions : Solutions //[[String:[String:Int]]]
    let pieces = ["F":"PieceF.png", "I":"PieceI.png", "L":"PieceL.png", "N":"PieceN.png", "P":"PieceP.png", "T":"PieceT.png", "U":"PieceU.png", "V":"PieceV.png", "W":"PieceW.png", "X":"PieceX.png", "Y":"PieceY.png", "Z":"PieceZ.png"]
    init () {
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "Solutions", withExtension: "plist")
        
        do {
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            allSolutions = try decoder.decode(Solutions.self, from: data)
        } catch {
            print(error)
            allSolutions = []
        }
    }

}
