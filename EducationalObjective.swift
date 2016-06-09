//
//  EducationalObjective.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData


class EducationalObjective: NSManagedObject {

    func addResult(obj: StudentResult){
        let results = self.mutableSetValueForKey("studentResults")
        results.addObject(obj)
    }
    
}
