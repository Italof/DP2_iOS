//
//  StudentResultsDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 08/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class StudentResultsDataLoader  {
    
    let dateFormatter = NSDateFormatter()
    
    func refresh_results (json: JSON) {
        
        StudentResult.MR_truncateAll()

        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var res = StudentResult.MR_findFirstByAttribute("id", withValue: Int(subJson["IdResultadoEstudiantil"].stringValue)!)
            
            if res != nil {
                //If the result exists, we update it's information
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                if date.isGreaterThanDate(res!.updated_at!) {
                    
                    res?.identificador = subJson["Identificador"].stringValue
                    res?.cicloRegistro = subJson["CicloRegistro"].stringValue
                    res?.descripcion = subJson["Descripcion"].stringValue
                    res?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    res?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                }
                
            } else {
                //If it doesn't, we create it
                res = StudentResult.MR_createEntity()
                
                res?.id = Int(subJson["IdResultadoEstudiantil"].stringValue)
                res?.identificador = subJson["Identificador"].stringValue
                res?.cicloRegistro = subJson["CicloRegistro"].stringValue
                res?.descripcion = subJson["Descripcion"].stringValue
                
                res?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                res?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                
            }
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
    }
}