//
//  Coordinator.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

class Coordinator: NSManagedObject {

    @NSManaged var id: NSNumber?
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var nombres: String?
    @NSManaged var apellidos: String?
    @NSManaged var email: String?
    @NSManaged var cargo: String?
    @NSManaged var vigente: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var faculty: Faculty?

}

//MARK: - Deserialization

extension Coordinator {
    
}

//MARK: - Core Data

extension Coordinator {
    
}