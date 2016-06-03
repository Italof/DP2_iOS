//
//  CourseTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 02/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class TR_Courses  {
    
    let dateFormatter = NSDateFormatter()
    
    func store(json: JSON, faculty: Faculty){
        //Clear previous data
        
        Course.MR_truncateAll()
        Timetable.MR_truncateAll()
        
        for (_,subJson):(String, JSON) in json {
            let course = Course.MR_createEntity()
            
            course?.id = Int(json["IdCurso"].stringValue)
            course?.idFaculty = Int(json["IdEspecialidad"].stringValue)
            course?.nivel = Int(json["NivelAcademico"].stringValue)
            course?.codigo = json["Codigo"].stringValue
            course?.nombre = json["Nombre"].stringValue

            for (_, schJson):(String, JSON) in subJson["schedules"] {
                
                let tm_reg = Timetable.MR_createEntity()
                
                tm_reg?.id = Int(schJson["IdHorario"].stringValue)
                tm_reg?.codigo = schJson["Codigo"].stringValue
                tm_reg?.alumnos = Int(schJson["TotalAlumnos"].stringValue)
                tm_reg?.curso = course
                course?.addTimeTable(tm_reg!)
                
                for (_, proJson):(String, JSON) in schJson["professors"] {
                    let pr_reg = Professor.MR_createEntity()
                    
                    pr_reg?.id = Int(proJson["IdDocente"].stringValue)
                    pr_reg?.nombres = proJson["Nombre"].stringValue + " " + proJson["ApellidoPaterno"].stringValue + " " + proJson["ApellidoMaterno"].stringValue
                    
                    pr_reg?.descripcion = proJson["Descripcion"].stringValue
                    pr_reg?.updated_at = self.dateFormatter.dateFromString(proJson["updated_at"].stringValue)
                    
                }
            }
            
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func get(faculty_id: NSNumber)->Dictionary<NSNumber,Array<Course>>? {
        
        let predicate:NSPredicate = NSPredicate(format: "(idFaculty = %@)", faculty_id)
        let request:NSFetchRequest = Course.MR_requestAllWithPredicate(predicate)
        let sortDescriptor = NSSortDescriptor(key: "idFaculty", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        let array = Course.MR_executeFetchRequest(request) as! Array<Course>
        return self.classifyResults(array)
    }
    
    
    func classifyResults(array: Array<Course>) -> Dictionary<NSNumber,Array<Course>>?{
        
        var studentResDictionary = Dictionary<NSNumber,Array<Course>>()
        var thisEdObj:NSNumber = 0
        
        for ed in array {
            thisEdObj = ed.nivel!
            
            if studentResDictionary.indexForKey(thisEdObj) == nil {
                studentResDictionary[thisEdObj] = []
            }
            
            studentResDictionary[thisEdObj]?.append(ed)
        }
        
        return studentResDictionary
    }
    
}