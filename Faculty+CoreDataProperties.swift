//
//  Faculty+CoreDataProperties.swift
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

extension Faculty {

    @NSManaged var codigo: String?
    @NSManaged var descripcion: String?
    @NSManaged var nombre: String?
    @NSManaged var id: NSNumber?
    @NSManaged var unidadAcademica: AcademicUnit?

}
