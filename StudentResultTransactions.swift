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
    
    func get(edObjective: NSNumber)->Array<StudentResult>? {
        
        let predicate:NSPredicate = NSPredicate(format: "(idObjetivoEd = %@)", edObjective)
        let request:NSFetchRequest = EducationalObjective.MR_requestAllWithPredicate(predicate)
        let sortDescriptor = NSSortDescriptor(key: "idEspecialidad", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        //return EducationalObjective.MR_executeFetchRequest(request) as? Array<EducationalObjective>
        
        return nil
    }
    
}