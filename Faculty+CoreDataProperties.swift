//
//  Faculty+CoreDataProperties.swift
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

extension Faculty {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var nombre: String?
    @NSManaged var codigo: String?
    @NSManaged var descripcion: String?
    @NSManaged var educationalObjective: NSSet?
    @NSManaged var aspect: NSSet?
    @NSManaged var course: NSSet?
    @NSManaged var studentResult: NSSet?
    @NSManaged var suggestion: NSSet?
    @NSManaged var improvementPlan: NSSet?
    @NSManaged var criterion: NSSet?
    @NSManaged var timetable: NSSet?
    @NSManaged var professor: NSSet?
    @NSManaged var planTypes: NSSet?
    @NSManaged var coordinator: Coordinator?

}
