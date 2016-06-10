//
//  Aspect.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData


class Aspect: NSManagedObject {

    func addCriterion(obj: Criterion){
        let criteria = self.mutableSetValueForKey("criteria")
        criteria.addObject(obj)
    }

}
