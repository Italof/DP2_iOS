//
//  EducationalObjective.swift
//  
//
//  Created by Karl Montenegro on 27/05/16.
//
//

import Foundation
import CoreData

class EducationalObjective: NSManagedObject {

    func addResult(res: StudentResult){
        let results = self.mutableSetValueForKey("studentResults")
        results.addObject(res)
    }
    
    func allResults()->NSSet{
        return self.mutableSetValueForKey("studentResults")
    }
}
