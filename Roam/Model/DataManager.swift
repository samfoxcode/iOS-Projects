//
//  DataManager.swift
//  US States
//
//  Created by John Hannan on 7/2/15.
//  Revised by John Hannan on 7/24/17
//  Revised by John Hannan on 11/6/17
//  Copyright (c) 2015, 2017 John Hannan. All rights reserved.
//
// The Data Manager implements the Core Data Stack and provides the following public methods/variables
//  managedObjectContext - needed by the model
//  saveContext() method
//  fetchManagedObjects method for performing a fetch
import Foundation
import CoreData


// Model should support this protocol
protocol DataManagerDelegate : class {  // need the class so delegate can be weak var
    var xcDataModelName : String { get }
    func createDatabase() -> Void
    var xcEntityName : String { get }
}

class DataManager {
    
    
    static let sharedInstance = DataManager()
    
    fileprivate init() {
        
    }
    
    
    
    weak var delegate : DataManagerDelegate? {
        didSet {
            if !self.databaseExists {
                delegate!.createDatabase()
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: self.delegate!.xcDataModelName)  // custom name
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            
        })
        container.viewContext.undoManager = UndoManager()
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext}()
    
    
    
    //MARK: Checking For Data
    var databaseExists : Bool  {return countEntities(for: (delegate?.xcEntityName)!) > 0}
    
    fileprivate func countEntities(for entityName:String) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = self.persistentContainer.viewContext
        let count = try! context.count(for: request)
        return count
    }
    
    
    //MARK: Fetching Data
    
    // fetch all objects for the given entity that satisfy the given predicate, and sort according to the sort keys
    // return the result as an array of NSManagedObjects
    func fetchManagedObjects(for entityName:String, sortKeys keys:[String], predicate pred:NSPredicate?) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = pred
        
        var descriptors : [NSSortDescriptor] = Array()
        for key in keys {
            let sortDescriptor = NSSortDescriptor(key: key, ascending: true)
            descriptors.append(sortDescriptor)
        }
        request.sortDescriptors = descriptors
        let context = self.persistentContainer.viewContext
        
        let results = (try! context.fetch(request)) as! [NSManagedObject]
        return results
    }
    
}
