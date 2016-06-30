//
//  Criterion.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let CriteriaIdKey = "IdCriterio"
let CriteriaAspectKey = "IdAspecto"
let CriteriaNameKey = "Nombre"
let CriteriaStatusKey = "Estado"

class Criterion: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var nombre: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var aspect: Aspect?
    @NSManaged var estado: NSNumber?

}

//MARK: Deserialization

extension Criterion {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[CriteriaIdKey].int32Value
        self.nombre = json[CriteriaNameKey].stringValue
        self.estado = json[CriteriaStatusKey].boolValue
        
    }
}

//MARK: Core Data

extension Criterion {
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Criterion>? {
        
        let persistedCriteria = Criterion.getCriterionByFaculty(fac, ctx: ctx)
        var newStoredCriteria:Array<Criterion> = []
        
        for (_,criteria):(String, JSON) in json {
            
            let newCriteria = Criterion.updateOrCreateWithJson(criteria, ctx: ctx)!
            newStoredCriteria.append(newCriteria)
            
        }
        
        let forDeletion = Array(Set(persistedCriteria).subtract(newStoredCriteria))
        
        for result in forDeletion {
            ctx.deleteObject(result)
        }
        
        return newStoredCriteria
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Criterion {
        var criteria: Criterion? = getCriteriaById(id, ctx: ctx)
        if (criteria == nil) {
            criteria = NSEntityDescription.insertNewObjectForEntityForName("Criterion", inManagedObjectContext: ctx) as? Criterion
            criteria!.id = id
        }
        return criteria!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Criterion? {
        var criteria: Criterion?
        
        let criteriaId = json[CriteriaIdKey].int32Value
        
        criteria = findOrCreateWithId(criteriaId, ctx: ctx)
        criteria?.setDataFromJson(json, ctx: ctx)
        
        return criteria
    }
    
    internal class func getCriteriaById(id: Int32, ctx: NSManagedObjectContext) -> Criterion? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Criterion", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let criteria = try! ctx.executeFetchRequest(fetchRequest) as? Array<Criterion>
        
        if (criteria != nil && criteria!.count > 0) {
            return criteria![0]
        }
        return nil
    }
    
    internal class func getAllCriteria(ctx: NSManagedObjectContext) -> Array<Criterion> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Criterion", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let criteria = try! ctx.executeFetchRequest(fetchRequest) as? Array<Criterion>
        return criteria ?? Array<Criterion>()
    }
    
    internal class func getCriterionByAspect(asp: Aspect, ctx: NSManagedObjectContext) -> Array<Criterion> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Criterion", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(aspect = %@)", asp)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let criteria = try! ctx.executeFetchRequest(fetchRequest) as? Array<Criterion>
        return criteria ?? Array<Criterion>()
    }
    
    internal class func getCriterionByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Criterion> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Criterion", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let criteria = try! ctx.executeFetchRequest(fetchRequest) as? Array<Criterion>
        return criteria ?? Array<Criterion>()
    }
}
