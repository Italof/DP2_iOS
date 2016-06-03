//
//  Course+CoreDataProperties.swift
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

extension Course {

    @NSManaged var id: NSNumber?
    @NSManaged var idFaculty: NSNumber?
    @NSManaged var nivel: NSNumber?
    @NSManaged var codigo: String?
    @NSManaged var nombre: String?
    @NSManaged var horarios: NSManagedObject?

}
