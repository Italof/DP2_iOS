//
//  ImprovementDataLoader.swift
//  UASApp
//
//  Created by Karl Montenegro on 10/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class ImprovementDataLoader {
    
    let dateFormatter = NSDateFormatter()
    
    func refresh_plans(json: JSON) {
        print(json)
        ImprovementPlan.MR_truncateAll()
        PlanType.MR_truncateAll()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        for (_,subJson):(String, JSON) in json {
            
            var plan = ImprovementPlan.MR_findFirstByAttribute("id", withValue: Int(subJson["IdPlanMejora"].stringValue)!)
            
            var professor = Professor.MR_findFirstByAttribute("id", withValue: Int(subJson["IdDocente"].stringValue)!)
            
            var type = PlanType.MR_findFirstByAttribute("id", withValue: Int(subJson["IdTipoPlanMejora"].stringValue)!)
            
            if plan != nil { //If plan exists, we update it's information
                
                let date:NSDate = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                
                //If the fetched date is newer we update the faculty information
                
                if date.isGreaterThanDate(plan!.updated_at!) {
                    
                    plan?.descripcion = subJson["Descripcion"].stringValue
                    plan?.analisisCausal = subJson["AnalisisCausal"].stringValue
                    plan?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                    plan?.fechaImplementacion = self.dateFormatter.dateFromString(subJson["FechaImplementacion"].stringValue)!
                    plan?.estado = subJson["Estado"].stringValue
                }
                
                
            } else { //If plan doesn't exists, we create it
                
                plan = ImprovementPlan.MR_createEntity()!
                
                plan?.id = Int(subJson["IdPlanMejora"].stringValue)!
                plan?.descripcion = subJson["Descripcion"].stringValue
                plan?.analisisCausal = subJson["AnalisisCausal"].stringValue
                plan?.updated_at = self.dateFormatter.dateFromString(subJson["updated_at"].stringValue)!
                plan?.fechaImplementacion = self.dateFormatter.dateFromString(subJson["FechaImplementacion"].stringValue)!
                plan?.estado = subJson["Estado"].stringValue
                
                plan?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(subJson["IdEspecialidad"].stringValue)!)
                
            }
            
            plan?.professor = nil
            let tJson = subJson["teacher"]
            
            if professor == nil { //Professor doesn't exist, we create it
                professor = Professor.MR_createEntity()
                
                professor?.id = Int(subJson["IdDocente"].stringValue)!
                professor?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(tJson["IdEspecialidad"].stringValue)!)
                professor?.codigo = tJson["Codigo"].stringValue
                professor?.nombres = tJson["Nombre"].stringValue
                professor?.apellidos = tJson["ApellidoPaterno"].stringValue + " " + tJson["ApellidoMaterno"].stringValue
                professor?.cargo = tJson["Cargo"].stringValue
                professor?.email = tJson["Correo"].stringValue
                professor?.descripcion = tJson["Descripcion"].stringValue
            }
            plan?.professor = professor
            
            plan?.planType = nil
            let pJson = subJson["type_improvement_plan"]
            
            if type == nil {
                type = PlanType.MR_createEntity()
                
                type?.id = Int(pJson["IdTipoPlanMejora"].stringValue)!
                type?.codigo = pJson["Codigo"].stringValue
                type?.faculty = Faculty.MR_findFirstByAttribute("id", withValue: Int(pJson["IdEspecialidad"].stringValue)!)
                type?.tema = pJson["Tema"].stringValue
                type?.descripcion = pJson["Descripcion"].stringValue
                type?.updated_at = self.dateFormatter.dateFromString(pJson["updated_at"].stringValue)!
            }
            
            plan?.planType = type
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        }
        
    }
    
    func get_plans(faculty: Faculty) -> Array<ImprovementPlan>? {
        
        let predicate:NSPredicate = NSPredicate(format: "(faculty.id = %@)", faculty.id!)
        let request:NSFetchRequest = ImprovementPlan.MR_requestAllWithPredicate(predicate)
        
        return ImprovementPlan.MR_executeFetchRequest(request) as? Array<ImprovementPlan>
    }
    
}