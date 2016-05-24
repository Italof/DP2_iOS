//
//  UserTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 23/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class UserTransactions {
    
    func loadUserInformation(array: [AnyObject]?) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        self.deleteAllUsers()
        
        
    }
    
    func deleteAllUsers() {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        var results: Array<User> = []
        
        do {
            try results = context.executeFetchRequest(request) as! Array<User>
        } catch {
            print(error)
        }
        
        for elem in results {
            context.deleteObject(elem)
        }
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
}