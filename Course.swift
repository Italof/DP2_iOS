//
//  Course.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData


class Course: NSManagedObject {
    
    func addTimeTable(obj: Timetable){
        let timetables = self.mutableSetValueForKey("timetables")
        timetables.addObject(obj)
    }

}
