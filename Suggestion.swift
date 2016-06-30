//
//  Suggestion.swift
//  
//
//  Created by Karl Montenegro on 10/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

/*
"IdSugerencia": 4,
"IdPlanMejora": "2",
"IdDocente": "4",
"IdEspecialidad": "1",
"Fecha": null,
"Titulo": "Grabar exposiciones",
"Descripcion": "Para revisar en qué fallan los alumnos",
"deleted_at": null,
"created_at": "2016-06-24 16:37:51",
"updated_at": "2016-06-24 16:37:51",
"teacher": {*/

let SuggestionIdKey = "IdSugerencia"
let SuggestionFacultyKey = "IdEspecialidad"
let SuggestionImprovementPlanKey = "IdPlanMejora"
let SuggestionDateKey = "Fecha"
let SuggestionTitleKey = "Titulo"
let SuggestionDescriptionKey = "Descripcion"
let SuggestionProfessorKey = "IdDocente"
let SuggestionProfessorDataKey = "teacher"

class Suggestion: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var faculty: Faculty?
    @NSManaged var improvementPlan: ImprovementPlan?
    @NSManaged var fecha: NSDate?
    @NSManaged var titulo: String?
    @NSManaged var descripcion: String?
    @NSManaged var professor: Professor?

}

//MARK: - Deserialization

extension Suggestion {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[SuggestionIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[SuggestionFacultyKey].int32Value, ctx: ctx)
        self.improvementPlan = ImprovementPlan.getPlanById(json[SuggestionImprovementPlanKey].int32Value, ctx: ctx)
        self.descripcion = json[SuggestionDescriptionKey].stringValue
        self.fecha = dateFormatter.dateFromString(json[SuggestionDateKey].stringValue)
        
    }
    
}


//MARK: - CoreData

extension Suggestion {
    
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Suggestion>? {
        
        let persistedSuggestions = Suggestion.getSuggestionsByFaculty(fac, ctx: ctx)
        var newStoredSuggestions:Array<Suggestion> = []
        
        for (_,suggestion):(String, JSON) in json {
            
            let newSuggestion = Suggestion.updateOrCreateWithJson(suggestion, ctx: ctx)!
            newStoredSuggestions.append(newSuggestion)
            
            let newTeacher = Professor.updateOrCreateWithJson(suggestion[SuggestionProfessorDataKey], ctx: globalCtx)
            newSuggestion.professor = newTeacher
        }
        
        let forDeletion = Array(Set(persistedSuggestions).subtract(newStoredSuggestions))
        
        for result in forDeletion {
            ctx.deleteObject(result)
        }

        return newStoredSuggestions
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Suggestion {
        var suggestion: Suggestion? = getSuggestionById(id, ctx: ctx)
        if (suggestion == nil) {
            suggestion = NSEntityDescription.insertNewObjectForEntityForName("Suggestion", inManagedObjectContext: ctx) as? Suggestion
            suggestion!.id = id
        }
        return suggestion!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Suggestion? {
        var suggestion: Suggestion?
        
        let suggestionId = json[SuggestionIdKey].int32Value
        
        suggestion = findOrCreateWithId(suggestionId, ctx: ctx)
        suggestion?.setDataFromJson(json, ctx: ctx)
        
        return suggestion
    }
    
    internal class func getSuggestionById(id: Int32, ctx: NSManagedObjectContext) -> Suggestion? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Suggestion", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let suggestions = try! ctx.executeFetchRequest(fetchRequest) as? Array<Suggestion>
        
        if (suggestions != nil && suggestions!.count > 0) {
            return suggestions![0]
        }
        return nil
    }
    
    internal class func getAllSuggestions(ctx: NSManagedObjectContext) -> Array<Suggestion> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Suggestion", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let suggestion = try! ctx.executeFetchRequest(fetchRequest) as? Array<Suggestion>
        return suggestion ?? Array<Suggestion>()
    }
    
    internal class func getSuggestionsByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Suggestion> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Suggestion", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let suggestions = try! ctx.executeFetchRequest(fetchRequest) as? Array<Suggestion>
        return suggestions ?? Array<Suggestion>()
    }
}