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

class SaveData {
    static let shared = SaveData()
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //save data
    func save(entityName: String, data: UserModel) {
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            if #available(iOS 10.0, *) {
                context = SaveData.appDelegate.persistentContainer.viewContext
            } else {
                // Fallback on earlier versions
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
                try context.save()
                print("Data Saved")
            } catch {
                print("Error saving data: \(error)")
            }
        }
    
    //fetch data
    public func fetchData(entityName: String) -> [UserDetails]? {
           var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
           if #available(iOS 10.0, *) {
               context = SaveData.appDelegate.persistentContainer.viewContext
           } else {
               // Fallback on earlier versions
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
    
    //Delete data
    public func deleteData(at index: Int,users:[UserDetails]) {
           let context = SaveData.appDelegate.persistentContainer.viewContext
           
           // Fetch the specific UserDetails object to delete
           let userToDelete = users[index]
           context.delete(userToDelete)
           
           do {
               try context.save()
           } catch {
               print("Failed to save context after deletion: \(error)")
           }
       }
    
}
