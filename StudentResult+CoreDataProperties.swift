//
//  StudentResult+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 26/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StudentResult {

    @NSManaged var updated_at: NSDate?
    @NSManaged var idEspecialidad: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var identificador: String?
    @NSManaged var id: NSNumber?
    @NSManaged var cicloRegistro: String?
    @NSManaged var educationalObjective: EducationalObjective?

}
