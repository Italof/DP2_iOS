//
//  Coordinator+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 23/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Coordinator {

    @NSManaged var id: NSNumber?
    @NSManaged var user: NSManagedObject?

}
