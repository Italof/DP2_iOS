//
//  Professor+CoreDataProperties.swift
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

extension Professor {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var nombres: String?
    @NSManaged var apellidos: String?
    @NSManaged var email: String?
    @NSManaged var cargo: String?
    @NSManaged var vigente: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var timetable: NSSet?

}
