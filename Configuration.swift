//
//  Configuration.swift
//  
//
//  Created by Karl Montenegro on 01/07/16.
//
//

import Foundation
import CoreData


class Configuration: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var acceptTreshold: Int32
    @NSManaged var expectedLevel: Int32
    @NSManaged var criteriaLevel: Int32
    @NSManaged var period: Period?
    @NSManaged var semesterStart: Semester?
    @NSManaged var semesterEnd: Semester?
    @NSManaged var faculty: Faculty?

}
