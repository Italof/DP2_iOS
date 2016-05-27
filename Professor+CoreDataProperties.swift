//
//  Professor+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 25/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Professor {
    
    @NSManaged var updated_at: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var nombres: String?
    @NSManaged var apellidos: String?
    @NSManaged var descripcion: String?
    @NSManaged var user: User?
}
