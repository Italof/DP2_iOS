//
//  Course.swift
//  Created by Karl Montenegro on 03/06/16.
//
//

import Foundation
import CoreData


class Course: NSManagedObject {

    func addTimeTable(res: Timetable){
        let objectives = self.mutableSetValueForKey("horarios")
        objectives.addObject(res)
    }

}
