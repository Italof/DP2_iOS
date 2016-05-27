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
    
    func addObjective(res: EducationalObjective){
        let objectives = self.mutableSetValueForKey("educationalObjectives")
        objectives.addObject(res)
    }
    
    func allObjectives()->NSSet{
        return self.mutableSetValueForKey("educationalObjectives")
    }
}
