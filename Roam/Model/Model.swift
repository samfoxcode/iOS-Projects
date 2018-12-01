//
//  File.swift
//  Roam
//
//  Created by Samuel Fox on 11/3/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import Foundation
import Firebase
import CoreData

enum FirebaseFields: String {
    case Posts
    case Users
    case Accounts
}

enum PostAttributes: String {
    case addedByUser
    case username
    case description
    case imagePath
    case experiences
    case travels
    case isPublic
    case postID
}

enum UserAttributes: String {
    case firstname
    case lastname
    case username
    case uid
    case email
}

struct NewUser {
    let firstname: String
    let lastname: String
    let username: String
    let uid: String
    let email: String
    
    init(firstname: String, lastname: String, username: String, uid: String, email: String){
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.uid = uid
        self.email = email
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.firstname = snapshotValue[UserAttributes.firstname.rawValue] as! String
        self.lastname = snapshotValue[UserAttributes.lastname.rawValue] as! String
        self.username = snapshotValue[UserAttributes.username.rawValue] as! String
        self.uid = snapshotValue[UserAttributes.uid.rawValue] as! String
        self.email = snapshotValue[UserAttributes.email.rawValue] as! String
    }
    
    func toObject() -> Any {
        return [
            UserAttributes.firstname.rawValue: self.firstname,
            UserAttributes.lastname.rawValue: self.lastname,
            UserAttributes.username.rawValue: self.username,
            UserAttributes.uid.rawValue: self.uid,
            UserAttributes.email.rawValue: self.email
        ]
    }
}

struct Post : PostIsh, Codable  {
    let addedByUser: String
    let username: String
    let description: String
    let imagePath: String
    let experiences: [String]
    let travels: [String]
    let isPublic: Bool
    let postID : String
    var cachedImage: UIImage? = nil
    
    var firstname : String {return addedByUser}
    var fullname : String {return addedByUser}
    
    enum CodingKeys : String, CodingKey {
        case addedByUser
        case username
        case description
        case imagePath
        case experiences
        case travels
        case isPublic
        case postID
    }
    
    init(addedByUser: String, username: String, description: String, imagePath: String, experiences: [String], travels: [String], isPublic: Bool, postID: String){
        self.addedByUser = addedByUser
        self.username = username
        self.description = description
        self.imagePath = imagePath
        self.experiences = experiences
        self.travels = travels
        self.isPublic = isPublic
        self.postID = postID
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.addedByUser = snapshotValue[PostAttributes.addedByUser.rawValue] as! String
        self.username = snapshotValue[PostAttributes.username.rawValue] as! String
        self.description = snapshotValue[PostAttributes.description.rawValue] as! String
        self.imagePath = snapshotValue[PostAttributes.imagePath.rawValue] as! String
        self.experiences = snapshotValue[PostAttributes.experiences.rawValue] as! [String]
        self.travels = snapshotValue[PostAttributes.travels.rawValue] as! [String]
        self.isPublic = snapshotValue[PostAttributes.isPublic.rawValue] as! Bool
        self.postID = snapshotValue[PostAttributes.postID.rawValue] as! String
    }
    
    func toObject() -> Any {
        return [
            PostAttributes.addedByUser.rawValue: self.addedByUser,
            PostAttributes.username.rawValue: self.username,
            PostAttributes.description.rawValue: self.description,
            PostAttributes.imagePath.rawValue: self.imagePath,
            PostAttributes.experiences.rawValue: self.experiences,
            PostAttributes.travels.rawValue: self.travels,
            PostAttributes.isPublic.rawValue: self.isPublic,
            PostAttributes.postID.rawValue: self.postID,
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
    
    func deleteExperienceAtIndex(_ index: Int) {
        experiences.remove(at: index)
    }
    
    func experienceAtIndex(_ index: Int) -> String{
        return experiences[index]
    }
    
    var experiencesCount: Int {return experiences.count}
    
}

class TravelInfo {
    static let sharedTravelsInstance = TravelInfo()
    
    var travels = [String]()
    
    func addTravel(_ travel: String) {
        travels.append(travel)
    }
    
    func removeTravel(_ travel: String) {
        let index = travels.firstIndex(of: travel)
        
        if let indexOfTravel = index {
            travels.remove(at: indexOfTravel)
        }
    }
    
    func deleteTravelAtIndex(_ index: Int) {
        travels.remove(at: index)
    }
    
    func travelAtIndex(_ index: Int) -> String{
        return travels[index]
    }
    
    var travelsCount: Int {return travels.count}
    
}

class CachedImages {
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func cacheImage(_ imageURL: String, _ image: UIImage) {
        let imageToCache = image
        imageCache.setObject(imageToCache, forKey: imageURL as AnyObject)
    }
    
    func getCachedImage(_ imageURL: String) -> UIImage? {
        return imageCache.object(forKey: imageURL as AnyObject) as? UIImage
    }
}
