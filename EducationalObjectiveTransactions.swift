//
//  EducationalObjectiveTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 25/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class TR_Ed_Objective {
    
    let dateFormatter = NSDateFormatter()
    
    func store(json: JSON, faculty: Faculty){
        //Clear previous data
        
        EducationalObjective.MR_truncateAll()
        
        for (_,subJson):(String, JSON) in json {
            let ed_obj = EducationalObjective.MR_createEntity()
            
            ed_obj?.id = Int(subJson["IdObjetivoEducacional"].stringValue)
            ed_obj?.idEspecialidad = Int(subJson["IdEspecialidad"].stringValue)
            ed_obj?.numero = Int(subJson["Numero"].stringValue)
            ed_obj?.descripcion = subJson["Descripcion"].stringValue
            ed_obj?.cicloReg = subJson["CicloRegistro"].stringValue
            ed_obj?.faculty = faculty
            ed_obj?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)
            
            for (_, sresJson):(String, JSON) in subJson["students_results"] {
               
                let st_res = StudentResult.MR_createEntity()
                
                st_res?.id = Int(sresJson["IdResultadoEstudiantil"].stringValue)
                st_res?.idEspecialidad = Int(sresJson["IdEspecialidad"].stringValue)
                st_res?.cicloRegistro = sresJson["CicloRegistro"].stringValue
                st_res?.descripcion = sresJson["Descripcion"].stringValue
                st_res?.identificador = sresJson["Identificador"].stringValue
                st_res?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)
                ed_obj?.addResult(st_res!)
                
            }
        
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func get(faculty_id: NSNumber)-> Array<EducationalObjective>?{
        
        let predicate:NSPredicate = NSPredicate(format: "(idEspecialidad = %@)", faculty_id)
        let request:NSFetchRequest = EducationalObjective.MR_requestAllWithPredicate(predicate)
        let sortDescriptor = NSSortDescriptor(key: "idEspecialidad", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        return EducationalObjective.MR_executeFetchRequest(request) as? Array<EducationalObjective>
    }
    
    func get(faculty_id: NSNumber)->Dictionary<String,Array<EducationalObjective>>? {
            
            let predicate:NSPredicate = NSPredicate(format: "(idEspecialidad = %@)", faculty_id)
            let request:NSFetchRequest = EducationalObjective.MR_requestAllWithPredicate(predicate)
            let sortDescriptor = NSSortDescriptor(key: "idEspecialidad", ascending: false)
            
            request.sortDescriptors = [sortDescriptor]
            let array = EducationalObjective.MR_executeFetchRequest(request) as! Array<EducationalObjective>
            return self.classifyObjectives(array)
    }
    
    
    func classifyObjectives(array: Array<EducationalObjective>) -> Dictionary<String,Array<EducationalObjective>>?{
        
        var edObjDictionary = Dictionary<String,Array<EducationalObjective>>()
        var thisEdObj:String = ""
        
        for ed in array {
            thisEdObj = ed.cicloReg!
            
            if edObjDictionary.indexForKey(thisEdObj) == nil {
                edObjDictionary[thisEdObj] = []
            }
            
            edObjDictionary[thisEdObj]?.append(ed)
        }
        
        return edObjDictionary
    }
}
