//
//  Semester.swift
//  
//
//  Created by Karl Montenegro on 30/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let SemesterIdKey = "IdCicloAcademico"
let SemesterDescriptionKey = "Descripcion"
let SemesterNumberKey = "Numero"


class Semester: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var course: NSSet?
    @NSManaged var descripcion: String?
    @NSManaged var number: String?
    @NSManaged var configSemesterStart: NSSet?
    @NSManaged var configSemesterEnd: NSSet?
    @NSManaged var period: Period?

}

//MARK: - Deserialization

extension Semester {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[SemesterIdKey].int32Value
        self.number = json[SemesterNumberKey].stringValue
        self.descripcion = json[SemesterDescriptionKey].stringValue
        
    }
    
}

//MARK: - Core Data

extension Semester {
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Semester {
        var semester: Semester? = getSemesterById(id, ctx: ctx)
        if (semester == nil) {
            semester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: ctx) as? Semester
            semester!.id = id
        }
        return semester!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Semester? {
        var semester: Semester?
        
        let semesterId = json[SemesterIdKey].int32Value
        
        semester = findOrCreateWithId(semesterId, ctx: ctx)
        semester?.setDataFromJson(json, ctx: ctx)
        
        return semester
    }
    
    internal class func getSemesterById(id: Int32, ctx: NSManagedObjectContext) -> Semester? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Semester", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let semesters = try! ctx.executeFetchRequest(fetchRequest) as? Array<Semester>
        
        if (semesters != nil && semesters!.count > 0) {
            return semesters![0]
        }
        return nil
    }
    
    internal class func getAllSemesters(ctx: NSManagedObjectContext) -> Array<Semester> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Semester", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let semester = try! ctx.executeFetchRequest(fetchRequest) as? Array<Semester>
        return semester ?? Array<Semester>()
    }
    
    internal class func getSemestersByPeriod(per: Period, ctx: NSManagedObjectContext) -> Array<Semester> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Semester", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(period = %@)", per)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let semesters = try! ctx.executeFetchRequest(fetchRequest) as? Array<Semester>
        return semesters ?? Array<Semester>()
    }
}
