//
//  CoursesDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 09/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class CourseDataLoader {
    
    let dateFormatter = NSDateFormatter()
    
    func refresh_courses(json: JSON) {
        Course.MR_truncateAll()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var course = Course.MR_findFirstByAttribute("id", withValue: Int(subJson["IdCurso"].stringValue)!)
            var faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
            
            
            if course != nil { //Course exists
                //We edit it
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                if date.isGreaterThanDate(course!.updated_at!) {
                    
                    course?.nivelAcademico = Int(subJson["NivelAcademico"].stringValue)!
                    course?.nombre = subJson["Nombre"].stringValue
                    course?.codigo = subJson["Codigo"].stringValue
                    course?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    course?.faculty = faculty
                }
                
            } else { //Course doesn't exists
                //We create it
                course = Course.MR_createEntity()
                
                course?.id = Int(subJson["IdCurso"].stringValue)!
                course?.nivelAcademico = Int(subJson["NivelAcademico"].stringValue)!
                course?.nombre = subJson["Nombre"].stringValue
                course?.codigo = subJson["Codigo"].stringValue
                course?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                course?.faculty = faculty
                
                
            }
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    func get_all(faculty: Faculty) -> Dictionary<NSNumber, Array<Course>>? {
        
        let array: Array<Course> = faculty.course?.allObjects as! Array<Course>
        
        var courseDictionary = Dictionary<NSNumber,Array<Course>>()
        var thisCourse:NSNumber = 0
        
        for course in array {
            thisCourse = course.nivelAcademico!
            
            if courseDictionary.indexForKey(thisCourse) == nil {
                courseDictionary[thisCourse] = []
            }
            
            courseDictionary[thisCourse]?.append(course)
        }
        return courseDictionary
    }
}