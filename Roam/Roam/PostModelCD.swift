//
//  File.swift
//  Roam
//
//  Created by Samuel Fox on 11/20/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import Foundation
import CoreData

protocol PostIsh {
    var fullname : String {get}
}

extension Post {
    func insert(using dataManager:DataManager) -> PostMO {
        let postMO = NSEntityDescription.insertNewObject(forEntityName: "PostMO", into: dataManager.managedObjectContext) as! PostMO
        postMO.firstname = self.firstname
        postMO.postDescription = self.description
        return postMO
    }
}

extension PostMO : PostIsh {
    
    var fullname : String {return self.firstname! + " " + self.lastname!}
    
    var info : String {
        get {return self.description}
    }
    
    // Need the @objc because NSFetchResultsController needs it
    @objc var firstLetter : String {
        let substring =  lastname![lastname!.startIndex...lastname!.startIndex]
        return String(substring)
    }
}

class PostsModelCD : DataManagerDelegate {
    var xcDataModelName = "RoamModel"
    var xcEntityName = "SavedPost"
    
    typealias Posts = [Post]
    
    static let sharedInstance = PostsModelCD()
    let dataManager = DataManager.sharedInstance
    
    
    //var posts = [PostMO]() // array of managed objects
    
    //MARK: Initialization
    fileprivate init() {
        dataManager.delegate = self
        
    }
    
    func createDatabase() {
        
    }
    
}
