//
//  AcademicUnit+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 20/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AcademicUnit {

    @NSManaged var nombre: String?
    @NSManaged var descripcion: String?
    @NSManaged var facultades: NSSet?

}
