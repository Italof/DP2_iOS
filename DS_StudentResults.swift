//
//  DS_StudentResults.swift
//  UASApp
//
//  Created by Karl Montenegro on 23/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class DS_StudentResults {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func getAll(id: NSNumber, obj: EducationalObjective)->Array<StudentResult>?{
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "StudentResult")
        let pred = NSPredicate(format: "(especialidad = %@) AND (educationalObjectives.id == %@)", id, obj.id)
        request.predicate = pred
        
        request.returnsObjectsAsFaults = false
        var results:Array<StudentResult> = []
        
        do{
            try results = context.executeFetchRequest(request) as! Array<StudentResult>
        }catch{
            print(error)
        }
        return results
    }
}