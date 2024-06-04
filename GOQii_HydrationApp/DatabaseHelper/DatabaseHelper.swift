//
//  SaveData.swift
//  MAHADASurvey
//
//  Created by webwerks on 26/12/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper {
    static let shared = DatabaseHelper()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private init() {
        
    }
    // MARK: save data
    func save(entityName: String, data: UserModel) {
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            if #available(iOS 10.0, *) {
                context = persistentContainer.viewContext
            } else {
            }
            guard let _ = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                print("Entity \(entityName) not found!")
                return
            }
            let newUser = UserDetails(context: context)
            newUser.id = data.id
            newUser.date = data.date
            newUser.waterIntake = data.waterIntake
            do {
                /// save the specific UserDetails
                try context.save()
                print("Data Saved")
            } catch {
                print("Error saving data: \(error)")
            }
        }
    
    // MARK: fetch data
    public func fetchData(entityName: String) -> [UserDetails]? {
           var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
           if #available(iOS 10.0, *) {
               context = persistentContainer.viewContext
           } else {
           }
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
           request.returnsObjectsAsFaults = false
           do {
               let result = try context.fetch(request) as? [UserDetails]
               return result
           } catch {
               print("Failed to fetch data: \(error)")
           }
           return nil
       }
    
    // MARK: Delete data
    public func deleteData(at index: Int,users:[UserDetails]) {
           let context = persistentContainer.viewContext
           
           /// Fetch the specific UserDetails object to delete
           let userToDelete = users[index]
           context.delete(userToDelete)
           
           do {
               try context.save()
           } catch {
               print("Failed to save context after deletion: \(error)")
           }
       }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GOQii_HydrationApp")
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
}
