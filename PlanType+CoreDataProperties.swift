//
//  PlanType+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 10/06/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PlanType {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var tema: String?
    @NSManaged var descripcion: String?
    @NSManaged var plans: NSSet?
    @NSManaged var faculty: Faculty?

}
