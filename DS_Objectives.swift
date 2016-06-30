//
//  DS_Objectives.swift
//  UASApp
//
//  Created by Karl Montenegro on 21/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class DS_Objectives {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let dateFormatter = NSDateFormatter()
    
    func storeObjectives(json: JSON) {

        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        //let list = self.getAll()
        
        /*for obj in list {
            context.deleteObject(context.objectWithID(obj))
        }*/
        
        
        for (_,subJson):(String, JSON) in json {
            
            var obj : EducationalObjective? = self.findObjective(Int(subJson["IdObjetivoEducacional"].stringValue)!)
            
            if obj == nil {
                obj = NSEntityDescription.insertNewObjectForEntityForName("EducationalObjective",inManagedObjectContext: context) as? EducationalObjective
                obj!.setValue(Int(subJson["IdObjetivoEducacional"].stringValue), forKey: "id")
            }
            
            obj!.setValue(Int(subJson["Numero"].stringValue),               forKey: "numero")
            obj!.setValue(Int(subJson["IdEspecialidad"].stringValue),       forKey: "especialidad")
            obj!.setValue(subJson["Descripcion"].stringValue,               forKey: "descripcion")
            obj!.setValue(subJson["CicloRegistro"].stringValue,             forKey: "cicloRegistro")
            obj!.setValue(subJson["Estado"].boolValue,                      forKey: "estado")
            obj!.setValue(self.dateFormatter.dateFromString(subJson["updated_at"].stringValue), forKey: "updated_at")
            
            for (_,res):(String,JSON) in json["students_results"] {
                
                var edRes : StudentResult? = self.findStudentResult(Int(res["IdResultadoEstudiantil"].stringValue)!)
                
                if edRes == nil {
                    edRes = NSEntityDescription.insertNewObjectForEntityForName("StudentResult",inManagedObjectContext: context) as? StudentResult
                    edRes!.setValue(Int(res["IdResultadoEstudiantil"].stringValue)!, forKey: "id")
                }
                
                edRes!.setValue(Int(res["IdResultadoEstudiantil"].stringValue), forKey: "id")
                edRes!.setValue(res["Identificador"].stringValue, forKey: "identificador")
                edRes!.setValue(res["Descripcion"].stringValue, forKey: "descripcion")
                edRes!.setValue(res["CicloRegistro"].stringValue, forKey: "cicloRegistro")
                edRes!.setValue(res["Estado"].boolValue, forKey: "estado")
                edRes!.setValue(Int(res["IdEspecialidad"].stringValue), forKey: "especialidad")
                edRes!.setValue(self.dateFormatter.dateFromString(res["updated_at"].stringValue)!, forKey: "updated_at")
                
                //obj!.addResult(edRes!)
            }
        }
        
        do{ try context.save() } catch { print(error) }
        
    }
    
    func getAll(fac: Faculty)->Array<EducationalObjective> {

        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "EducationalObjective")
        let pred = NSPredicate(format: "(especialidad = %@)", fac.id)
        request.predicate = pred
        request.returnsObjectsAsFaults = false
        
        var results : [EducationalObjective] = []
        
        do{
            results = try context.executeFetchRequest(request) as! [EducationalObjective]
        }catch{
            print(error)
        }
        
        return results
        
    }
    
    func getAll()->Array<NSManagedObjectID> {
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "EducationalObjective")
        request.returnsObjectsAsFaults = false
        
        var results : [EducationalObjective] = []
        
        do{
            results = try context.executeFetchRequest(request) as! [EducationalObjective]
        }catch{
            print(error)
        }
        
        var list : [NSManagedObjectID] = []
        
        for obj in results {
            list.append(obj.objectID)
        }
        
        return list
    }

    //MARK - Auxiliary functions
    
    private func findObjective(id: NSNumber)->EducationalObjective? {
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("EducationalObjective", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(id = %@)", id)
        request.entity = entity
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result.firstObject as? EducationalObjective

    }
    
    private func findStudentResult(id: NSNumber)->StudentResult? {
       
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("StudentResult", inManagedObjectContext: context)
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(id = %@)", id)
        request.entity = entity
        request.predicate = pred
        
        var result:NSArray = []
        
        do{
            try result = context.executeFetchRequest(request)
        }catch{
            print(error)
        }
        
        return result[0] as? StudentResult
        
    }
    
    func deleteAll() {
     
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "EducationalObjective")
        fetchRequest.returnsObjectsAsFaults = false
        
        var results : Array<EducationalObjective> = []
        
        do{
            results = try context.executeFetchRequest(fetchRequest) as! Array<EducationalObjective>
        }catch{}
        
        for managedObject in results {
            context.deleteObject(managedObject)
        }
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
    
}