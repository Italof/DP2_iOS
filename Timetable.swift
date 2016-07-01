//
//  Timetable.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

/*
 "IdHorario": 3,
 "IdCursoxCiclo": "1",
 "Codigo": "H0601",
 "TotalAlumnos": null,
 "deleted_at": null,
 "created_at": "2016-06-23 18:05:08",
 "updated_at": "2016-06-23 18:05:08",
 "professors"
 */

let TimetableIdKey = "IdHorario"
let TimetableCodeKey = "Codigo"
let TimetableStudentsKey = "TotalAlumnos"
let TimetableProfessorsKey = "professors"
let TimetableEvidenceKey = "course_evidences"

class Timetable: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var totalAlumnos: Int32
    @NSManaged var faculty: Faculty?
    @NSManaged var course: Course?
    @NSManaged var professor: NSSet?

}

//MARK: Deserialization

extension Timetable {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[TimetableIdKey].int32Value
        self.codigo = json[TimetableCodeKey].stringValue
        self.totalAlumnos = json[TimetableStudentsKey].int32Value
        
    }
    
}

//MARK: Core Data

extension Timetable {
    
    func addProfessor(obj: Professor){
        let professors = self.mutableSetValueForKey("professor")
        professors.addObject(obj)
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Timetable {
        var timetable: Timetable? = getTimetableById(id, ctx: ctx)
        if (timetable == nil) {
            timetable = NSEntityDescription.insertNewObjectForEntityForName("Timetable", inManagedObjectContext: ctx) as? Timetable
            timetable!.id = id
        }
        return timetable!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Timetable? {
        var timetable: Timetable?
        
        let timetableId = json[TypeIdKey].int32Value
        
        timetable = findOrCreateWithId(timetableId, ctx: ctx)
        timetable?.setDataFromJson(json, ctx: ctx)
        
        return timetable
    }
    
    internal class func getTimetableById(id: Int32, ctx: NSManagedObjectContext) -> Timetable? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Timetable", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let timetables = try! ctx.executeFetchRequest(fetchRequest) as? Array<Timetable>
        
        if (timetables != nil && timetables!.count > 0) {
            return timetables![0]
        }
        return nil
    }
    
    internal class func getAllTimetables(ctx: NSManagedObjectContext) -> Array<Timetable> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Timetable", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let timetable = try! ctx.executeFetchRequest(fetchRequest) as? Array<Timetable>
        return timetable ?? Array<Timetable>()
    }
    
    internal class func getTimetablesByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Timetable> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Timetable", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let timetables = try! ctx.executeFetchRequest(fetchRequest) as? Array<Timetable>
        return timetables ?? Array<Timetable>()
    }
    
    internal class func getTimetablesByCourse(crs: Course, ctx: NSManagedObjectContext) -> Array<Timetable> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Timetable", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(course = %@)", crs)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let timetables = try! ctx.executeFetchRequest(fetchRequest) as? Array<Timetable>
        return timetables ?? Array<Timetable>()
    }
}
