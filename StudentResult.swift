//
//  StudentResult.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData


class StudentResult: NSManagedObject {

    func addObjective(obj: EducationalObjective){
        let objectives = self.mutableSetValueForKey("educationalObjectives")
        objectives.addObject(obj)
    }
}
