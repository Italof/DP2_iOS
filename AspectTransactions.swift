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
    
    func store(json: JSON) {
        
        //Clear previous data
        Faculty.MR_truncateAll()
        
        for (_,subJson):(String, JSON) in json {
            let fac = Faculty.MR_createEntity()
            fac?.id = Int(subJson["IdEspecialidad"].stringValue)
            fac?.codigo = subJson["Codigo"].stringValue
            fac?.nombre = subJson["Nombre"].stringValue
            fac?.descripcion = subJson["Descripcion"].stringValue
            fac?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func get()-> Array<Faculty>?{
        return Faculty.MR_findAll() as! Array<Faculty>
    }
    
    
}