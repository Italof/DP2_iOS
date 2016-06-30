//
//  Aspect.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

/*
 {
 "IdAspecto": 1,
 "IdResultadoEstudiantil": "1",
 "Nombre": "Matemáticas",
 "deleted_at": null,
 "created_at": "2016-06-18 20:03:28",
 "updated_at": "2016-06-24 20:25:49",
 "Estado": "1",
 "criterion": [
 {
 "IdCriterio": 1,
 "IdAspecto": "1",
 "Nombre": "Aplica conceptos lógicos para la resolucion de problemas",
 "deleted_at": null,
 "created_at": "2016-06-18 20:29:37",
 "updated_at": "2016-06-24 20:25:49",
 "Estado": "1"
 }
 ]
 }
 */

let AspectIdKey = "IdAspecto"
let AspectResultKey = "IdResultadoEstudiantil"
let AspectNombreKey = "Nombre"
let AspectStatusKey = "Estado"
let AspectCriteriaKey = "criterion"

class Aspect: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var nombre: String?
    @NSManaged var estado: NSNumber?
    @NSManaged var criteria: NSSet?
    @NSManaged var studentResult: StudentResult?
    @NSManaged var faculty: Faculty?

}

//MARK: - Deserialization

extension Aspect {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[AspectIdKey].int32Value
        self.nombre = json[AspectNombreKey].stringValue
        self.estado = json[AspectStatusKey].boolValue
        self.studentResult = StudentResult.getResultById(json[AspectResultKey].int32Value, ctx: globalCtx)
    }
    
}

//MARK: - Core Data

extension Aspect {
    
    func addCriterion(obj: Criterion){
        let criteria = self.mutableSetValueForKey("criteria")
        criteria.addObject(obj)
    }
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Aspect>? {
        
        let persistedAspects = Aspect.getAllAspects(ctx)
        var newStoredAspects:Array<Aspect> = []
        
        for aspect in persistedAspects {
            ctx.deleteObject(aspect)
        }
        
        for (_,aspect):(String, JSON) in json {
            
            let newAspect = Aspect.updateOrCreateWithJson(aspect, ctx: ctx)!
            
            newStoredAspects.append(newAspect)
            
            // Student Results Associated to the Objectives
            /*
            let persistedResults = StudentResult.getResultsByFaculty(fac, ctx: ctx)
            
            for result in persistedResults {
                ctx.deleteObject(result)
            }*/
            
            //print("OBJECTIVE:")
            //print("============")
            //print(newObjective)
            //print("RESULTS")
            //print("============")
            /*
            for (_,result):(String, JSON) in objective[ObjectiveResultsKey] {
                
                let newResult = StudentResult.updateOrCreateWithJson(result, ctx: ctx)
                //print(newResult?.identificador)
                let results = newObjective.mutableSetValueForKey("studentResults")
                results.addObject(newResult!)
            }*/
        }
        
        return newStoredAspects
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Aspect {
        var aspect: Aspect? = getAspectById(id, ctx: ctx)
        if (aspect == nil) {
            aspect = NSEntityDescription.insertNewObjectForEntityForName("Aspect", inManagedObjectContext: ctx) as? Aspect
            aspect!.id = id
        }
        return aspect!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Aspect? {
        var aspect: Aspect?
        
        let aspectId = json[AspectIdKey].int32Value
        
        aspect = findOrCreateWithId(aspectId, ctx: ctx)
        aspect?.setDataFromJson(json, ctx: ctx)
        
        return aspect
    }
    
    internal class func getAspectById(id: Int32, ctx: NSManagedObjectContext) -> Aspect? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Aspect", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let aspects = try! ctx.executeFetchRequest(fetchRequest) as? Array<Aspect>
        
        if (aspects != nil && aspects!.count > 0) {
            return aspects![0]
        }
        return nil
    }
    
    internal class func getAllAspects(ctx: NSManagedObjectContext) -> Array<Aspect> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Aspect", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aspects = try! ctx.executeFetchRequest(fetchRequest) as? Array<Aspect>
        return aspects ?? Array<Aspect>()
    }
    
    internal class func getAspectByResult(res: StudentResult, ctx: NSManagedObjectContext) -> Array<Aspect> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Aspect", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(studentResult = %@)", res)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aspects = try! ctx.executeFetchRequest(fetchRequest) as? Array<Aspect>
        return aspects ?? Array<Aspect>()
    }
    
    internal class func getClassifiedAspectsByResult(fac: Faculty, ctx: NSManagedObjectContext) -> Dictionary<String,Array<Aspect>>? {
        
        let aspects:Array<Aspect> = Aspect.getAllAspects(ctx)
        var dictionary = Dictionary<String,Array<Aspect>>()
        var thisObj:String = ""
        
        for asp in aspects {
            thisObj = (asp.studentResult?.identificador!)!
            if dictionary.indexForKey(thisObj) == nil {
                dictionary[thisObj] = []
            }
            dictionary[thisObj]?.append(asp)
        }
        
        return dictionary
    }
}
