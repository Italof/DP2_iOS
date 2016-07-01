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

let CourseIdKey = "IdCurso"
let CourseFacultyKey = "IdEspecialidad"
let CourseLevelKey = "NivelAcademico"
let CourseCodeKey = "Codigo"
let CourseNameKey = "Nombre"
let CourseSchedulesKey = "schedules"
let CourseEvidencesKey = "course_evidences"
let CourseSemestersKey = "semesters"

class Course: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var nivelAcademico: Int32
    @NSManaged var codigo: String?
    @NSManaged var nombre: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var timetables: NSSet?
    @NSManaged var semester: NSSet?

}

extension Course {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[CourseIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[CourseFacultyKey].int32Value, ctx: ctx)
        self.codigo = json[CourseCodeKey].stringValue
        self.nombre = json[CourseNameKey].stringValue
        self.nivelAcademico = json[CourseLevelKey].int32Value
    }
    
}

extension Course {

    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Course>? {
        
        let persistedCourses = Course.getCoursesByFaculty(fac, ctx: ctx)
        var newStoredCourses:Array<Course> = []
        
        for (_,course):(String, JSON) in json {
            
            let newCourse = Course.updateOrCreateWithJson(course, ctx: ctx)!
            newStoredCourses.append(newCourse)
            
            let persitedTimetables = Timetable.getTimetablesByCourse(newCourse, ctx: ctx)
            var newStoredTimetables:Array<Timetable> = []
            
            for(_,timetable):(String,JSON) in course[CourseSchedulesKey] {
                
                let newTimetable = Timetable.updateOrCreateWithJson(timetable, ctx: ctx)!
                
                let tables = newCourse.timetables?.mutableSetValueForKey("timetables")
                tables?.addObject(newTimetable)
                newStoredTimetables.append(newTimetable)
            }
            
            let forDeletion = Array(Set(persitedTimetables).subtract(newStoredTimetables))
            
            for timetable in forDeletion {
                ctx.deleteObject(timetable)
            }
            
        }
        
        let forDeletion = Array(Set(persistedCourses).subtract(newStoredCourses))
        
        for course in forDeletion {
            ctx.deleteObject(course)
        }
        
        return newStoredCourses
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Course {
        var course: Course? = getCourseById(id, ctx: ctx)
        if (course == nil) {
            course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: ctx) as? Course
            course!.id = id
        }
        return course!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Course? {
        var course: Course?
        
        let courseId = json[ResultIdKey].int32Value
        
        course = findOrCreateWithId(courseId, ctx: ctx)
        course?.setDataFromJson(json, ctx: ctx)
        
        return course
    }
    
    internal class func getCourseById(id: Int32, ctx: NSManagedObjectContext) -> Course? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let courses = try! ctx.executeFetchRequest(fetchRequest) as? Array<Course>
        
        if (courses != nil && courses!.count > 0) {
            return courses![0]
        }
        return nil
    }
    
    internal class func getAllCourses(ctx: NSManagedObjectContext) -> Array<Course> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let courses = try! ctx.executeFetchRequest(fetchRequest) as? Array<Course>
        return courses ?? Array<Course>()
    }
    
    internal class func getCoursesByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Course> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let courses = try! ctx.executeFetchRequest(fetchRequest) as? Array<Course>
        return courses ?? Array<Course>()
    }
    
    internal class func getClassifiedCoursesByLevel(fac: Faculty, ctx: NSManagedObjectContext) -> Dictionary<Int32, Array<Course>>? {
        
        let courses:Array<Course> = Course.getCoursesByFaculty(fac, ctx: ctx)
        var dictionary = Dictionary<Int32,Array<Course>>()
        var thisCourse:Int32 = 0
        
        for course in courses {
            thisCourse = course.nivelAcademico
            if dictionary.indexForKey(thisCourse) == nil {
                dictionary[thisCourse] = []
            }
            dictionary[thisCourse]?.append(course)
        }
        
        return dictionary
        
    }
}
