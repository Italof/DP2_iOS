//
//  StudentResult.swift
//  
//
//  Created by Karl Montenegro on 26/05/16.
//
//

import Foundation
import CoreData

class StudentResult: NSManagedObject {

    @NSManaged var updated_at: NSDate?
    @NSManaged var idEspecialidad: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var identificador: String?
    @NSManaged var id: NSNumber?
    @NSManaged var cicloRegistro: String?
    @NSManaged var educationalObjective: EducationalObjective?
}
