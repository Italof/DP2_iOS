//
//  Period.swift
//  
//
//  Created by Karl Montenegro on 01/07/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let PeriodIdKey = "IdPeriodo"
let PeriodStatusKey = "Vigente"
let PeriodFacultyKey = "IdEspecialidad"
let PeriodSemestersKey = "semesters"

class Period: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var status: NSNumber?
    @NSManaged var semesters: NSSet?
    @NSManaged var configuration: Configuration?
    @NSManaged var faculty: Faculty?

}

//MARK: - Deserialization

extension Period {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[PeriodIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[PeriodFacultyKey].int32Value, ctx: ctx)
        self.status = Int(json[PeriodStatusKey].stringValue)
        
    }
    
}

//MARK: - Core Data


extension Period {
    
    func addSemester(per: Semester){
        let semesters = self.mutableSetValueForKey("semesters")
        semesters.addObject(per)
    }
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Period? {
        
        let persistedPeriods = Period.getPeriodsByFaculty(fac, ctx: ctx)
        
        let newPeriod = Period.updateOrCreateWithJson(json , ctx: ctx)!
        
        let persistedSemesters = Semester.getSemestersByPeriod(newPeriod, ctx: ctx)
        var newStoredSemesters : Array<Semester> = []
        
        for (_,semester):(String, JSON) in json["semesters"] {
            let newSemester = Semester.updateOrCreateWithJson(semester, ctx: ctx)!
            
            print(newSemester)
            
            newSemester.period = newPeriod
            newStoredSemesters.append(newSemester)
        }
        
        let forDeletion = Array(Set(persistedSemesters).subtract(newStoredSemesters))
        
        for semester in forDeletion {
            ctx.deleteObject(semester)
        }
        
        return newPeriod
    }
    
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Period {
        var period: Period? = getPeriodById(id, ctx: ctx)
        if (period == nil) {
            period = NSEntityDescription.insertNewObjectForEntityForName("Period", inManagedObjectContext: ctx) as? Period
            period!.id = id
        }
        return period!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Period? {
        var period: Period?
        
        let periodId = json[PeriodIdKey].int32Value
        
        period = findOrCreateWithId(periodId, ctx: ctx)
        period?.setDataFromJson(json, ctx: ctx)
        
        return period
    }
    
    internal class func getPeriodById(id: Int32, ctx: NSManagedObjectContext) -> Period? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Period", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let periods = try! ctx.executeFetchRequest(fetchRequest) as? Array<Period>
        
        if (periods != nil && periods!.count > 0) {
            return periods![0]
        }
        return nil
    }
    
    internal class func getAllPeriods(ctx: NSManagedObjectContext) -> Array<Period> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Period", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let period = try! ctx.executeFetchRequest(fetchRequest) as? Array<Period>
        return period ?? Array<Period>()
    }
    
    internal class func getPeriodsByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Period> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Period", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let periods = try! ctx.executeFetchRequest(fetchRequest) as? Array<Period>
        return periods ?? Array<Period>()
    }
}