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
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // MARK: save data
    func save(entityName: String, data: UserModel) {
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            if #available(iOS 10.0, *) {
                context = DatabaseHelper.appDelegate.persistentContainer.viewContext
            } else {
            }
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
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
               context = DatabaseHelper.appDelegate.persistentContainer.viewContext
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
           let context = DatabaseHelper.appDelegate.persistentContainer.viewContext
           
           /// Fetch the specific UserDetails object to delete
           let userToDelete = users[index]
           context.delete(userToDelete)
           
           do {
               try context.save()
           } catch {
               print("Failed to save context after deletion: \(error)")
           }
       }
    
}
