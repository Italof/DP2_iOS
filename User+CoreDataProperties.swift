//
//  User+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 25/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var updated_at: NSDate?
    @NSManaged var idDocente: NSNumber?
    @NSManaged var idCoordinador: NSNumber?
    @NSManaged var professor: Professor?
    @NSManaged var coordinator: Coordinator?

}
