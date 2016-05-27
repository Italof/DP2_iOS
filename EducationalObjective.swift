//
//  EducationalObjective.swift
//  
//
//  Created by Karl Montenegro on 25/05/16.
//
//

import Foundation
import CoreData


class EducationalObjective: NSManagedObject {

    @NSManaged var id: NSNumber?
    @NSManaged var numero: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var cicloReg: String?
    @NSManaged var idEspecialidad: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var faculty: Faculty?

}
