//
//  Period.swift
//  
//
//  Created by Karl Montenegro on 01/07/16.
//
//

import Foundation
import CoreData


class Period: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var status: NSNumber?
    @NSManaged var semesters: NSSet?
    @NSManaged var configuration: Configuration?

}
