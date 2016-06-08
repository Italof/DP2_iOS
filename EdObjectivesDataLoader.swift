//
//  EdObjectivesDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 07/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class EdObjectiveDataLoader {
    
    let endpoint: Connection = Connection()
    let dateFormatter = NSDateFormatter()
    
    func refresh_objectives (json: JSON) {
        
        EducationalObjective.MR_truncateAll()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var obj = EducationalObjective.MR_findFirstByAttribute("id", withValue: Int(subJson["IdObjetivoEducacional"].stringValue)!)
            
            if obj != nil {
                //If the objective exists, we update it's information
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                if date.isGreaterThanDate(obj!.updated_at!) {
                    
                    obj?.numero = Int(subJson["Numero"].stringValue)
                    obj?.cicloRegistro = subJson["CicloRegistro"].stringValue
                    obj?.descripcion = subJson["Descripcion"].stringValue
                    obj?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    
                    obj?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                }
                
            } else {
                //If it doesn't, we create it
                obj = EducationalObjective.MR_createEntity()
                
                obj?.id = Int(subJson["IdObjectivoEducacional"].stringValue)
                obj?.numero = Int(subJson["Numero"].stringValue)
                obj?.cicloRegistro = subJson["CicloRegistro"].stringValue
                obj?.descripcion = subJson["Descripcion"].stringValue
                obj?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                obj?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                
            }
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
    
    func get_all(faculty: Faculty) -> Dictionary<String, Array<EducationalObjective>>? {
        
        let array: Array<EducationalObjective> = faculty.educationalObjective?.allObjects as! Array<EducationalObjective>
        
        var objDictionary = Dictionary<String,Array<EducationalObjective>>()
        var thisObj:String = ""
        
        for obj in array {
            thisObj = obj.cicloRegistro!
            
            if objDictionary.indexForKey(thisObj) == nil {
                objDictionary[thisObj] = []
            }
            
            objDictionary[thisObj]?.append(obj)
        }
        return objDictionary
    }
    
}