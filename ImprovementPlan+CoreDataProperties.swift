//
//  ImprovementPlan+CoreDataProperties.swift
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

extension ImprovementPlan {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var analisisCausal: String?
    @NSManaged var hallazgo: String?
    @NSManaged var descripcion: String?
    @NSManaged var fechaImplementacion: NSDate?
    @NSManaged var estado: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var planType: PlanType?
    @NSManaged var professor: Professor?
    @NSManaged var suggestions: NSSet?

}
