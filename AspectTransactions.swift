//
//  AspectTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 27/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class TR_Aspect {
    
    let dateFormatter = NSDateFormatter()
    
    func store(json: JSON, faculty: Faculty) {
        
        //Clear previous data
        Aspect.MR_truncateAll()
        
        for (_,subJson):(String, JSON) in json {
            let asp = Aspect.MR_createEntity()
            
            asp?.id = Int(subJson["IdAspecto"].stringValue)
            asp?.idStudentResult = Int(subJson["IdResultadoEstudiantil"].stringValue)
            asp?.nombre = subJson["Nombre"].stringValue
            asp?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)
            asp?.faculty = faculty
            asp?.idEspecialidad = faculty.id
            
            for (_,crJson):(String, JSON) in json["criterion"] {
                let crt = Criterion.MR_createEntity()
                
                crt?.id = Int(crJson["IdCriterio"].stringValue)
                crt?.idAspect = Int(crJson["IdAspecto"].stringValue)
                crt?.nombre = crJson["Nombre"].stringValue
                crt?.updated_at = self.dateFormatter.dateFromString(crJson["updated_at"].stringValue)
                
                asp?.addCriteria(crt!)
            }
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func get(faculty_id: NSNumber)-> Array<Aspect>?{
        
        let predicate:NSPredicate = NSPredicate(format: "(idEspecialidad = %@)", faculty_id)
        let request:NSFetchRequest = Aspect.MR_requestAllWithPredicate(predicate)
        let sortDescriptor = NSSortDescriptor(key: "idEspecialidad", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        return Aspect.MR_executeFetchRequest(request) as? Array<Aspect>
    }
    
    
}