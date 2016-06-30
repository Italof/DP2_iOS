//
//  AspectDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 08/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class AspectDataLoader {
    
    let dateFormatter = NSDateFormatter()
    
    func refresh_aspects (json: JSON) {
        
        //Aspect.MR_truncateAll()
        //Criterion.MR_truncateAll()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var asp = Aspect.MR_findFirstByAttribute("id", withValue: Int(subJson["IdAspecto"].stringValue)!)
        
            
            if asp != nil {
                //If the result exists, we update it's information
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                if date.isGreaterThanDate(asp!.updated_at!) {
                    
                    asp?.nombre = subJson["Nombre"].stringValue
                    asp?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    asp?.studentResult = StudentResult.MR_findFirstByAttribute("id", withValue: Int(subJson["IdResultadoEstudiantil"].stringValue)!)
                }
                
            } else {
                //If it doesn't, we create it
                asp = Aspect.MR_createEntity()
                
                //asp?.id = Int(subJson["IdAspecto"].stringValue)
                asp?.nombre = subJson["Nombre"].stringValue
                
                asp?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                asp?.studentResult = StudentResult.MR_findFirstByAttribute("id", withValue: Int(subJson["IdResultadoEstudiantil"].stringValue)!)
            }
            var crJson = subJson["criterion"]
            
            for (_,cr):(String,JSON) in crJson {
                var criteria = Criterion.MR_findFirstByAttribute("id", withValue: Int(cr["IdCriterio"].stringValue)!)
                
                if criteria == nil {
                    criteria = Criterion.MR_createEntity()
                    
                    //criteria?.id = Int(cr["IdCriterio"].stringValue)!
                    criteria?.nombre = cr["Nombre"].stringValue
                    criteria?.updated_at = self.dateFormatter.dateFromString(cr["updated_at"].stringValue)!
                }
                asp?.addCriterion(criteria!)
            }
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    func get_all(faculty: Faculty) -> Array<Aspect>? {
        return nil
    }
    
    func get_criteria(aspect: Aspect) -> Array<Criterion>? {
        
        //et predicate:NSPredicate = NSPredicate(format: "(aspect.id = %@)", aspect.id!)
        //let request:NSFetchRequest = Criterion.MR_requestAllWithPredicate(predicate)
        
        return nil//Criterion.MR_executeFetchRequest(request) as? Array<Criterion>
    }
}