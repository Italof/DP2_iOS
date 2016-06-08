//
//  StudentResult+CoreDataProperties.swift
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

extension StudentResult {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var identificador: String?
    @NSManaged var descripcion: String?
    @NSManaged var cicloRegistro: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var educationalObjective: EducationalObjective?
    @NSManaged var aspects: NSSet?

}
