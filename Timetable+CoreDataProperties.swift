//
//  Timetable+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 03/06/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Timetable {

    @NSManaged var id: NSNumber?
    @NSManaged var codigo: String?
    @NSManaged var alumnos: NSNumber?
    @NSManaged var profesor: Professor?
    @NSManaged var curso: Course?

}
