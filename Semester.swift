//
//  Semester.swift
//  
//
//  Created by Karl Montenegro on 30/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


class Semester: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var course: Course?
    @NSManaged var descripcion: String?
    @NSManaged var numero: Int32
    @NSManaged var configSemesterStart: NSSet?
    @NSManaged var configSemesterEnd: NSSet?

}
