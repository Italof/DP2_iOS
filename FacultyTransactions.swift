//
//  FacultyTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 20/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class FacultyTransactions {
    
    //Faculty Load from JSON
    func loadFaculties(array: [AnyObject]?) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        for elem in array! {
            let faculty = NSEntityDescription.insertNewObjectForEntityForName("Faculty",inManagedObjectContext: context)
            faculty.setValue(elem.valueForKey("Codigo"), forKey: "codigo")
            faculty.setValue(elem.valueForKey("Descripcion"), forKey: "descripcion")
            faculty.setValue(elem.valueForKey("Nombre"), forKey: "nombre")
            if elem.valueForKey("academic_unit") != nil {
                
            }
        }
        
        do{ try context.save() }catch{ print(error) }
    }
    
    //Get all faculties
    
    func all() -> Array<Faculty>? {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Faculty")
        request.returnsObjectsAsFaults = false
        
        var results:Array<Faculty> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<Faculty>
        }catch{
            print(error)
        }
        return results
    }
}