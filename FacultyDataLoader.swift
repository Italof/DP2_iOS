//
//  FacultyDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 07/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class FacultyDataLoader {
    
    let endpoint: Connection = Connection()
    let dateFormatter = NSDateFormatter()
    let context = NSManagedObjectContext.MR_defaultContext()
    
    func refresh_faculties (json: JSON, completion: (Bool)->()) {
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")

        //Faculty.MR_truncateAll()
        
        for (_,subJson):(String, JSON) in json {
            
            var fac = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
            
            if fac != nil { //If faculty exists, we update it's information
                
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                //If the fetched date is newer we update the faculty information
                
                if date.isGreaterThanDate(fac!.updated_at!) {
                    
                    fac?.codigo = subJson["Codigo"].stringValue
                    fac?.nombre = subJson["Nombre"].stringValue
                    fac?.descripcion = subJson["Descripcion"].stringValue
                    fac?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                }
                
            } else { //If faculty doesn't exists, we create it
                
                fac = Faculty.MR_createEntity()
                
                //fac?.id = Int(subJson["IdEspecialidad"].stringValue)
                fac?.codigo = subJson["Codigo"].stringValue
                fac?.nombre = subJson["Nombre"].stringValue
                fac?.descripcion = subJson["Descripcion"].stringValue
                fac?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
            }
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(){
            comp, error in
            if error != nil {
                completion(comp)
            } else {
                completion(comp)
            }
        }
        
    }
    
}



