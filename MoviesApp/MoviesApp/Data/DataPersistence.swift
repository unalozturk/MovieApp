//
//  FavoritePersistence.swift
//  MoviesApp
//
//  Created by ÜNAL ÖZTÜRK on 5.04.2020.
//  Copyright © 2020 ÜNAL ÖZTÜRK. All rights reserved.
//

import Foundation
import CoreData

class DataPersistence {
    
    static let containerName: String = "Favorites"
    static let entityName: String = "Favorites"
    static let attributeName: String = "idNumber"
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    // MARK: - Core Data Saving support
    static private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Fetching
    static func fetchFavorites() -> [Int] {
        var favoritesItems = [Int]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResults = try persistentContainer.viewContext.fetch(fetchRequest)
            
            for item in fetchResults as! [NSManagedObject]{
                if let idNumber = item.value(forKey: attributeName) as? Int {
                    favoritesItems.append(idNumber)
                }
            }
        } catch let error{
            print(error.localizedDescription)
        }
        
        return favoritesItems
    }
    
    // MARK: - Core Data Add
    static func favoriteItem(moveId: Int){
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
        let item = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
        item.setValue(moveId, forKey: attributeName)
        saveContext()
    }
    
    // MARK: - Core Data Remove
    static func removeFavoriteItem(moveId: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate.init(format: "\(attributeName)==\(moveId)")
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects as! [NSManagedObject] {
                context.delete(object)
            }
            saveContext()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
