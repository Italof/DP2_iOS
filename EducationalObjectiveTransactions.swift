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
    
    func store(json: JSON){
        //Clear previous data
        
        EducationalObjective.MR_truncateAll()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        for (index,subJson):(String, JSON) in json {
            let ed_obj = EducationalObjective.MR_createEntity()
            
            /*
            fac?.id = Int(subJson["IdEspecialidad"].stringValue)
            fac?.descripcion = subJson["Descripcion"].stringValue
            fac?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            */
        }
    }
    
    func get(faculty_id: Int)-> Array<EducationalObjective>?{
        return EducationalObjective.MR_findAll() as! Array<EducationalObjective>
    }
    
}
