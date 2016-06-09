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
        
        //EducationalObjective.MR_truncateAll()
        //StudentResult.MR_truncateAll()
        
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
                    
                    obj?.valueForKey("studentResults")?.removeAllObjects()
                    
                    for (_,resJson):(String, JSON) in subJson["students_results"] {
                        
                        var res = StudentResult.MR_findFirstByAttribute("id", withValue: Int(resJson["IdResultadoEstudiantil"].stringValue)!)
                        
                        if res != nil { //Result found, we update it
                            
                            let date:NSDate = self.dateFormatter.dateFromString(resJson["updated_at"].stringValue)!
                            
                            if date.isGreaterThanDate(res!.updated_at!) {
                                obj?.addResult(res!)
                            }
                            
                        } else { //Result not found, we create it
                            res = StudentResult.MR_createEntity()
                            
                            res?.id = Int(subJson["IdResultadoEstudiantil"].stringValue)
                            res?.identificador = resJson["Identificador"].stringValue
                            res?.cicloRegistro = resJson["CicloRegistro"].stringValue
                            res?.descripcion = resJson["Descripcion"].stringValue
                            
                            res?.updated_at = self.dateFormatter.dateFromString(resJson["updated_at"].stringValue)!
                            obj?.addResult(res!)
                        }
                    }
                }
                
            } else {
                //If it doesn't, we create it
                obj = EducationalObjective.MR_createEntity()
                
                obj?.id = Int(subJson["IdObjetivoEducacional"].stringValue)
                obj?.numero = Int(subJson["Numero"].stringValue)
                obj?.cicloRegistro = subJson["CicloRegistro"].stringValue
                obj?.descripcion = subJson["Descripcion"].stringValue
                obj?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                obj?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                
                for (_,resJson):(String, JSON) in subJson["students_results"] {
                    
                    var res = StudentResult.MR_findFirstByAttribute("id", withValue: Int(resJson["IdResultadoEstudiantil"].stringValue)!)
                    
                    if res != nil { //Result found, we update it
                        
                        let date:NSDate = self.dateFormatter.dateFromString(resJson["updated_at"].stringValue)!
                        
                        if date.isGreaterThanDate(res!.updated_at!) {
                            obj?.addResult(res!)
                        }
                        
                    } else { //Result not found, we create it
                        res = StudentResult.MR_createEntity()
                        
                        res?.id = Int(subJson["IdResultadoEstudiantil"].stringValue)
                        res?.identificador = resJson["Identificador"].stringValue
                        res?.cicloRegistro = resJson["CicloRegistro"].stringValue
                        res?.descripcion = resJson["Descripcion"].stringValue
                        
                        res?.updated_at = self.dateFormatter.dateFromString(resJson["updated_at"].stringValue)!
                        obj?.addResult(res!)
                    }
                }
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