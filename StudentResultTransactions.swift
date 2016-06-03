//
//  StudentResultTransactions.swift
//  UASApp
//
//  Created by Karl Montenegro on 02/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class TR_StudentResults {
    
    func get(faculty_id: NSNumber)->Dictionary<String,Array<StudentResult>>? {
        
        let predicate:NSPredicate = NSPredicate(format: "(idEspecialidad = %@)", faculty_id)
        let request:NSFetchRequest = StudentResult.MR_requestAllWithPredicate(predicate)
        let sortDescriptor = NSSortDescriptor(key: "idEspecialidad", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        let array = StudentResult.MR_executeFetchRequest(request) as! Array<StudentResult>
        return self.classifyResults(array)
    }
    
    
    func classifyResults(array: Array<StudentResult>) -> Dictionary<String,Array<StudentResult>>?{
        
        var studentResDictionary = Dictionary<String,Array<StudentResult>>()
        var thisEdObj:String = ""
        
        for ed in array {
            thisEdObj = ed.cicloRegistro!
            
            if studentResDictionary.indexForKey(thisEdObj) == nil {
                studentResDictionary[thisEdObj] = []
            }
            
            studentResDictionary[thisEdObj]?.append(ed)
        }
        
        return studentResDictionary
    }
    
}