//
//  EducationalObjective.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


let ObjectiveIdKey = "IdObjetivoEducacional"
let ObjectiveFacultyKey = "IdEspecialidad"
let ObjectiveNumberKey = "Numero"
let ObjectiveDescriptionKey = "Descripcion"
let ObjectiveCicloRegistroKey = "CicloRegistro"
let ObjectiveStatusKey = "Estado"
let ObjectiveResultsKey = "students_results"

class EducationalObjective: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var numero: Int32
    @NSManaged var descripcion: String?
    @NSManaged var cicloRegistro: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var studentResults: NSSet?
    @NSManaged var estado: NSNumber?
    @NSManaged var especialidad: NSNumber?
    
}

//MARK: - Deserialization

extension EducationalObjective {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[ObjectiveIdKey].int32Value
        self.numero = json[ObjectiveNumberKey].int32Value
        self.descripcion = json[ObjectiveDescriptionKey].stringValue
        self.cicloRegistro = json[ObjectiveCicloRegistroKey].stringValue
        self.faculty = Faculty.getFacultyById(json[ObjectiveFacultyKey].int32Value, ctx: ctx)
        self.estado = json[ObjectiveStatusKey].boolValue
    }
}

//MARK: - CoreData

extension EducationalObjective {
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<EducationalObjective>? {
        
        let persistedObjectives = EducationalObjective.getObjectivesByFaculty(fac, ctx: ctx)
        var newStoredObjectives:Array<EducationalObjective> = []
        
        for objective in persistedObjectives {
            ctx.deleteObject(objective)
        }
        
        for (_,objective):(String, JSON) in json {
            
            let newObjective = EducationalObjective.updateOrCreateWithJson(objective, ctx: ctx)!
            
            newStoredObjectives.append(newObjective)
            
            // Student Results Associated to the Objectives
            
            let persistedResults = StudentResult.getResultsByFaculty(fac, ctx: ctx)
            
            for result in persistedResults {
                ctx.deleteObject(result)
            }
            
            //print("OBJECTIVE:")
            //print("============")
            //print(newObjective)
            //print("RESULTS")
            //print("============")
            
            for (_,result):(String, JSON) in objective[ObjectiveResultsKey] {
                
                let newResult = StudentResult.updateOrCreateWithJson(result, ctx: ctx)
                //print(newResult?.identificador)
                let results = newObjective.mutableSetValueForKey("studentResults")
                results.addObject(newResult!)
            }
        }
        
        return newStoredObjectives
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> EducationalObjective {
        var objective: EducationalObjective? = getObjectiveById(id, ctx: ctx)
        if (objective == nil) {
            objective = NSEntityDescription.insertNewObjectForEntityForName("EducationalObjective", inManagedObjectContext: ctx) as? EducationalObjective
            objective!.id = id
        }
        return objective!
    }
    
    private class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> EducationalObjective? {
        var objective: EducationalObjective?
        
        let objectiveId = json[ObjectiveIdKey].int32Value
        
        objective = findOrCreateWithId(objectiveId, ctx: ctx)
        objective?.setDataFromJson(json, ctx: ctx)
        
        return objective
    }
    
    internal class func getObjectiveById(id: Int32, ctx: NSManagedObjectContext) -> EducationalObjective? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("EducationalObjective", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let objectives = try! ctx.executeFetchRequest(fetchRequest) as? Array<EducationalObjective>
        
        if (objectives != nil && objectives!.count > 0) {
            return objectives![0]
        }
        return nil
    }
    
    internal class func getAllObjectives(ctx: NSManagedObjectContext) -> Array<EducationalObjective> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("EducationalObjective", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let objectives = try! ctx.executeFetchRequest(fetchRequest) as? Array<EducationalObjective>
        return objectives ?? Array<EducationalObjective>()
    }
    
    internal class func getObjectivesByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<EducationalObjective> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("EducationalObjective", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let objectives = try! ctx.executeFetchRequest(fetchRequest) as? Array<EducationalObjective>
        return objectives ?? Array<EducationalObjective>()
    }
    
}