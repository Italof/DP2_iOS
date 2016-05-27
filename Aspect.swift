//
//  Aspect.swift
//  
//
//  Created by Karl Montenegro on 27/05/16.
//
//

import Foundation
import CoreData


class Aspect: NSManagedObject {

    func addCriteria(crt: Criterion){
        let criteria = self.mutableSetValueForKey("criteria")
        criteria.addObject(crt)
    }

}
