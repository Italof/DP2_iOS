//
//  Faculty.swift
//  
//
//  Created by Karl Montenegro on 25/05/16.
//
//

import Foundation
import CoreData

class Faculty: NSManagedObject {

    @NSManaged var updated_at: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var nombre: String?
    @NSManaged var codigo: String?
    @NSManaged var descripcion: String?
    @NSManaged var educationalObjectives: NSSet?
    
}
