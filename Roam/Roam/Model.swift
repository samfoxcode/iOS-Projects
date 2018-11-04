//
//  File.swift
//  Roam
//
//  Created by Samuel Fox on 11/3/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import Foundation
import Firebase

enum PostAttributes: String {
    case addedByUser
    case description
    case imagePath
    case flights
    case itinerary
    case stays
    case isPublic
}

struct Post {
    let addedByUser: String
    let description: String
    let imagePath: String
    let flights: String
    let itinerary: String
    let stays: String
    let isPublic: Bool

    init(addedByUser: String, description: String, imagePath: String, flights: String, itinerary: String, stays: String, isPublic: Bool){
        self.addedByUser = addedByUser
        self.description = description
        self.imagePath = imagePath
        self.flights = flights
        self.itinerary = itinerary
        self.stays = stays
        self.isPublic = isPublic
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.addedByUser = snapshotValue[PostAttributes.addedByUser.rawValue] as! String
        self.description = snapshotValue[PostAttributes.description.rawValue] as! String
        self.imagePath = snapshotValue[PostAttributes.imagePath.rawValue] as! String
        self.flights = snapshotValue[PostAttributes.flights.rawValue] as! String
        self.itinerary = snapshotValue[PostAttributes.itinerary.rawValue] as! String
        self.stays = snapshotValue[PostAttributes.stays.rawValue] as! String
        self.isPublic = snapshotValue[PostAttributes.isPublic.rawValue] as! Bool
    }
    
    func toObject() -> Any {
        return [
            PostAttributes.addedByUser.rawValue:addedByUser,
            PostAttributes.description.rawValue:description,
            PostAttributes.imagePath.rawValue:imagePath,
            PostAttributes.flights.rawValue:flights,
            PostAttributes.itinerary.rawValue:itinerary,
            PostAttributes.stays.rawValue:stays,
            PostAttributes.isPublic.rawValue:isPublic,
        ]
    }
}
