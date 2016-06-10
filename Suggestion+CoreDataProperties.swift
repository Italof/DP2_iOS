//
//  Suggestion+CoreDataProperties.swift
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

extension Suggestion {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var faculty: Faculty?
    @NSManaged var improvementPlan: ImprovementPlan?

}
