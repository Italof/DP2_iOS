//
//  SuggestionDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 10/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class SuggestionDataLoader {
    
    let dateFormatter = NSDateFormatter()
    
    func refresh_suggestions(json: JSON) {
        
        Suggestion.MR_truncateAll()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
            var professor = Professor.MR_findFirstByAttribute("id", withValue: Int(subJson["IdDocente"].stringValue)!)
            var plan = ImprovementPlan.MR_findFirstByAttribute("id", withValue: Int(subJson["IdPlanMejora"].stringValue)!)
            
            var suggestion = Suggestion.MR_findFirstByAttribute("id", withValue: Int(subJson["IdSugerencia"].stringValue)!)
            
            if suggestion != nil { //Exists, we edit it
                
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                //If the fetched date is newer we update the suggestion information
                
                if date.isGreaterThanDate(suggestion!.updated_at!) {
                    
                    suggestion?.improvementPlan = plan
                    suggestion?.fecha = self.dateFormatter.dateFromString(subJson["Fecha"].stringValue)!
                    suggestion?.titulo = subJson["Titulo"].stringValue
                    suggestion?.descripcion = subJson["Descripcion"].stringValue
                    suggestion?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    suggestion?.faculty = faculty
                }
                
            } else { //Doesn't exists, we create it
                suggestion = Suggestion.MR_createEntity()
                
                suggestion?.id = Int(subJson["IdSugerencia"].stringValue)!
                suggestion?.improvementPlan = plan
                suggestion?.fecha = self.dateFormatter.dateFromString(subJson["Fecha"].stringValue)
                suggestion?.titulo = subJson["Titulo"].stringValue
                suggestion?.descripcion = subJson["Descripcion"].stringValue
                suggestion?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                suggestion?.faculty = faculty
            }
            
            let tJson = subJson["teacher"]
            
            if professor == nil {
                professor = Professor.MR_createEntity()
                
                professor?.id = Int(subJson["IdDocente"].stringValue)!
                professor?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(tJson["IdEspecialidad"].stringValue)!)
                professor?.codigo = tJson["Codigo"].stringValue
                professor?.nombres = tJson["Nombre"].stringValue
                professor?.apellidos = tJson["ApellidoPaterno"].stringValue + " " + tJson["ApellidoMaterno"].stringValue
                professor?.cargo = tJson["Cargo"].stringValue
                professor?.email = tJson["Correo"].stringValue
                professor?.descripcion = tJson["Descripcion"].stringValue
                professor?.updated_at = self.dateFormatter.dateFromString(tJson["updated_at"].stringValue)!
            }
            suggestion?.professor = professor
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    func get_all(faculty: Faculty)-> Array<Suggestion>? {
        let predicate:NSPredicate = NSPredicate(format: "(faculty.id = %@)", faculty.id!)
        let request:NSFetchRequest = Suggestion.MR_requestAllWithPredicate(predicate)
        
        return Suggestion.MR_executeFetchRequest(request) as? Array<Suggestion>
    }
    
}