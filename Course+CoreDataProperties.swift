//
//  Course+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Course {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var nivelAcademico: NSNumber?
    @NSManaged var codigo: String?
    @NSManaged var nombre: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var timetables: NSSet?

}
