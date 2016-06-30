//
//  Course.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

class Course: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var nivelAcademico: NSNumber?
    @NSManaged var codigo: String?
    @NSManaged var nombre: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var timetables: NSSet?
    @NSManaged var semester: Semester?

}

extension Course {
    func addTimeTable(obj: Timetable){
        let timetables = self.mutableSetValueForKey("timetables")
        timetables.addObject(obj)
    }
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Course>? {
        /*
        let persistedCourses = Course.getCoursesByFaculty(fac, ctx: ctx)*/
        var newStoredCourses:Array<Course> = []
        /*
        for course in persistedCourses {
            ctx.deleteObject(course)
        }
        
        for (_,course):(String, JSON) in json {
            
            let newCourse = Course.updateOrCreateWithJson(course, ctx: ctx)!
            newStoredCourses.append(newCourse)
            
            //Aspects
            
            let persistedAspects = Course.getCourseByFaculty(newResult, ctx: ctx)
            
            for aspect in persistedAspects {
                ctx.deleteObject(aspect)
            }
            
            for (_,aspect):(String, JSON) in result[ResultAspectKey] {
                
                let newAspect = Aspect.updateOrCreateWithJson(aspect, ctx: ctx)
                
                let aspects = newResult.mutableSetValueForKey("aspects")
                aspects.addObject(newAspect!)
            }
        }
        */
        return newStoredCourses
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> StudentResult {
        var result: StudentResult? = getResultById(id, ctx: ctx)
        if (result == nil) {
            result = NSEntityDescription.insertNewObjectForEntityForName("StudentResult", inManagedObjectContext: ctx) as? StudentResult
            result!.id = id
        }
        return result!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> StudentResult? {
        var result: StudentResult?
        
        let resultId = json[ResultIdKey].int32Value
        
        result = findOrCreateWithId(resultId, ctx: ctx)
        result?.setDataFromJson(json, ctx: ctx)
        
        return result
    }
    
    internal class func getResultById(id: Int32, ctx: NSManagedObjectContext) -> StudentResult? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("StudentResult", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let results = try! ctx.executeFetchRequest(fetchRequest) as? Array<StudentResult>
        
        if (results != nil && results!.count > 0) {
            return results![0]
        }
        return nil
    }
    
    internal class func getAllReults(ctx: NSManagedObjectContext) -> Array<StudentResult> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("StudentResult", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let results = try! ctx.executeFetchRequest(fetchRequest) as? Array<StudentResult>
        return results ?? Array<StudentResult>()
    }
    
    internal class func getResultsByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<StudentResult> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("StudentResult", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "identificador", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let results = try! ctx.executeFetchRequest(fetchRequest) as? Array<StudentResult>
        return results ?? Array<StudentResult>()
    }
    
    internal class func getResultsByObjective(obj: EducationalObjective, ctx: NSManagedObjectContext) -> Array<StudentResult> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("StudentResult", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "ANY educationalObjectives.id == %d", Int(obj.id))
        let sortDescriptor = NSSortDescriptor(key: "identificador", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let results = try! ctx.executeFetchRequest(fetchRequest) as? Array<StudentResult>
        return results ?? Array<StudentResult>()
    }
}
