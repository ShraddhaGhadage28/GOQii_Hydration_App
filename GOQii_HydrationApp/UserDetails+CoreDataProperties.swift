//
//  UserDetails+CoreDataProperties.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var waterIntake: String?

}

extension UserDetails : Identifiable {

}
