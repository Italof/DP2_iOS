//
//  PlanType.swift
//  
//
//  Created by Karl Montenegro on 10/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let TypeIdKey = "IdTipoPlanMejora"
let TypeFacultyKey = "IdEspecialidad"
let TypeCodeKey = "Codigo"
let TypeSubjectKey = "Tema"
let TypeDescriptionKey = "Descripcion"

class PlanType: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var tema: String?
    @NSManaged var descripcion: String?
    @NSManaged var plans: NSSet?
    @NSManaged var faculty: Faculty?

}

//MARK: Deserialization

extension PlanType {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[TypeIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[TypeFacultyKey].int32Value, ctx: ctx)
        self.codigo = json[TypeCodeKey].stringValue
        self.tema = json[TypeSubjectKey].stringValue
        self.descripcion = json[TypeDescriptionKey].stringValue
        
    }
    
}

//MARK: Core Data

extension PlanType {
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<PlanType>? {
        
        let persistedTypes = PlanType.getTypesByFaculty(fac, ctx: ctx)
        var newStoredTypes:Array<PlanType> = []
        
        for (_,type):(String, JSON) in json {
            
            let newType = PlanType.updateOrCreateWithJson(type, ctx: ctx)!
            newStoredTypes.append(newType)
            
        }
        
        let forDeletion = Array(Set(persistedTypes).subtract(newStoredTypes))
        
        for result in forDeletion {
            ctx.deleteObject(result)
        }
        
        return newStoredTypes
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> PlanType {
        var type: PlanType? = getTypeById(id, ctx: ctx)
        if (type == nil) {
            type = NSEntityDescription.insertNewObjectForEntityForName("PlanType", inManagedObjectContext: ctx) as? PlanType
            type!.id = id
        }
        return type!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> PlanType? {
        var type: PlanType?
        
        let typeId = json[TypeIdKey].int32Value
        
        type = findOrCreateWithId(typeId, ctx: ctx)
        type?.setDataFromJson(json, ctx: ctx)
        
        return type
    }
    
    internal class func getTypeById(id: Int32, ctx: NSManagedObjectContext) -> PlanType? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("PlanType", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let types = try! ctx.executeFetchRequest(fetchRequest) as? Array<PlanType>
        
        if (types != nil && types!.count > 0) {
            return types![0]
        }
        return nil
    }
    
    internal class func getAllTypes(ctx: NSManagedObjectContext) -> Array<PlanType> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("PlanType", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let type = try! ctx.executeFetchRequest(fetchRequest) as? Array<PlanType>
        return type ?? Array<PlanType>()
    }
    
    internal class func getTypesByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<PlanType> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("PlanType", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let types = try! ctx.executeFetchRequest(fetchRequest) as? Array<PlanType>
        return types ?? Array<PlanType>()
    }
}
