//
//  Professor.swift
//  
//
//  Created by Karl Montenegro on 25/05/16.
//
//

import Foundation
import CoreData

class Professor: NSManagedObject {

    @NSManaged var updated_at: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var nombres: String?
    @NSManaged var apellidos: String?
    @NSManaged var descripcion: String?
    @NSManaged var user: User?
}