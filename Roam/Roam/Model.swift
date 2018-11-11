//
//  File.swift
//  Roam
//
//  Created by Samuel Fox on 11/3/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseFields: String {
    case Posts
    case Users
}

enum PostAttributes: String {
    case addedByUser
    case username
    case description
    case imagePath
    case flights
    case itinerary
    case stays
    case isPublic
}

struct Post {
    let addedByUser: String
    let username: String
    let description: String
    let imagePath: String
    let flights: String
    let itinerary: String
    let stays: String
    let isPublic: Bool

    init(addedByUser: String, username: String, description: String, imagePath: String, flights: String, itinerary: String, stays: String, isPublic: Bool){
        self.addedByUser = addedByUser
        self.username = username
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
        self.username = snapshotValue[PostAttributes.username.rawValue] as! String
        self.description = snapshotValue[PostAttributes.description.rawValue] as! String
        self.imagePath = snapshotValue[PostAttributes.imagePath.rawValue] as! String
        self.flights = snapshotValue[PostAttributes.flights.rawValue] as! String
        self.itinerary = snapshotValue[PostAttributes.itinerary.rawValue] as! String
        self.stays = snapshotValue[PostAttributes.stays.rawValue] as! String
        self.isPublic = snapshotValue[PostAttributes.isPublic.rawValue] as! Bool
    }
    
    func toObject() -> Any {
        return [
            PostAttributes.addedByUser.rawValue: self.addedByUser,
            PostAttributes.username.rawValue: self.username,
            PostAttributes.description.rawValue: self.description,
            PostAttributes.imagePath.rawValue: self.imagePath,
            PostAttributes.flights.rawValue: self.flights,
            PostAttributes.itinerary.rawValue: self.itinerary,
            PostAttributes.stays.rawValue: self.stays,
            PostAttributes.isPublic.rawValue: self.isPublic,
        ]
    }
}

class Experiences {
    static let sharedExperiencesInstance = Experiences()
    
    var experiences = [String]()
    
    func addExperience(_ experience: String) {
        experiences.append(experience)
    }
    
    func removeExperience(_ experience: String) {
        let index = experiences.firstIndex(of: experience)
        
        if let indexOfExperience = index {
            experiences.remove(at: indexOfExperience)
        }
    }
    
    func experienceAtIndex(_ index: Int) -> String{
        return experiences[index]
    }
    
    var experiencesCount: Int {return experiences.count}
    
}
