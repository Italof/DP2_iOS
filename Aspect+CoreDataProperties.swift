//
//  Aspect+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 27/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Aspect {

    @NSManaged var id: NSNumber?
    @NSManaged var idStudentResult: NSNumber?
    @NSManaged var nombre: String?
    @NSManaged var updated_at: NSDate?
    @NSManaged var criteria: NSSet?
    @NSManaged var faculty: Faculty?
    @NSManaged var idEspecialidad: NSNumber?

}
