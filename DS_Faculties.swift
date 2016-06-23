//
//  DS_Faculties.swift
//  UASApp
//
//  Created by Karl Montenegro on 21/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class DS_Faculties {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let dateFormatter = NSDateFormatter()
    
    init(){
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
    }
    
    func storeObjectives(json: JSON) {
        
    }
    
    func getAll()->Array<Faculty>?{
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
    
    //MARK: - Auxiliary functions
}