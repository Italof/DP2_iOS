//
//  StudentResult.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let ResultIdKey = "IdResultadoEstudiantil"
let ResultFacultyKey = "IdEspecialidad"
let ResultIdentifierKey = "Identificador"
let ResultDescriptionKey = "Descripcion"
let ResultCicloRegistroKey = "CicloRegistro"
let ResultStatusKey = "Estado"

/*
 {
 "IdResultadoEstudiantil": 14,
 "IdEspecialidad": "2",
 "Identificador": "B",
 "Descripcion": "Diseñar y conducir experimentos, así como analizar e interpretar datos.",
 "CicloRegistro": null,
 "deleted_at": null,
 "created_at": "2016-06-18 19:46:28",
 "updated_at": "2016-06-18 19:46:28",
 "Estado": "0",
 "pivot": {
 "IdObjetivoEducacional": "4",
 "IdResultadoEstudiantil": "14"
 }
 }
 */

class StudentResult: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var identificador: String?
    @NSManaged var descripcion: String?
    @NSManaged var cicloRegistro: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var educationalObjectives: NSSet?
    @NSManaged var aspects: NSSet?
    @NSManaged var especialidad: Int32
    @NSManaged var estado: NSNumber?
    
}

//MARK: - Deserialization

extension StudentResult {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[ResultIdKey].int32Value
        self.identificador = json[ResultIdentifierKey].stringValue
        self.descripcion = json[ResultDescriptionKey].stringValue
        self.cicloRegistro = json[ResultCicloRegistroKey].stringValue
        self.faculty = Faculty.getFacultyById(json[ResultFacultyKey].int32Value, ctx: ctx)
        self.estado = json[ResultStatusKey].boolValue
    }
    
}


//MARK: - CoreData

extension StudentResult {
    
    func addObjective(obj: EducationalObjective){
        let objectives = self.mutableSetValueForKey("educationalObjectives")
        objectives.addObject(obj)
    }
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<StudentResult>? {
        
        let persistedResults = StudentResult.getResultsByFaculty(fac, ctx: ctx)
        var newStoredResults:Array<StudentResult> = []
        
        for result in persistedResults {
            ctx.deleteObject(result)
        }
        
        for (_,result):(String, JSON) in json {
            newStoredResults.append(StudentResult.updateOrCreateWithJson(result, ctx: ctx)!)
        }
        
        return newStoredResults
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
    /*
    internal class func getOrderedResults(faculty: Faculty) -> Dictionary<String, Array<StudentResult>>? {
        
        let array: Array<StudentResult> = StudentResult.getResultsByFaculty(faculty, ctx: globalCtx)
        
        var resDictionary = Dictionary<String,Array<StudentResult>>()
        var thisObj:String?
        
        for res in array {
            thisObj =
            
            if objDictionary.indexForKey(thisObj) == nil {
                objDictionary[thisObj] = []
            }
            
            objDictionary[thisObj]?.append(obj)
        }
        return objDictionary
    }*/
}

