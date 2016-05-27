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
            /*
            for (_, sresJson):(String, JSON) in json["students_results"] {
                let st_res = StudentResult.MR_createEntity()
            }
            */
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
    
}
