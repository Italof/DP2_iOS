//
//  Professor+CoreDataProperties.swift
//  
//
//  Created by Karl Montenegro on 23/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Professor {

    @NSManaged var id: NSNumber?
    @NSManaged var correo: String?
    @NSManaged var nombre: String?
    @NSManaged var codigo: String?
    @NSManaged var apellidoPaterno: String?
    @NSManaged var apellidoMaterno: String?
    @NSManaged var descripcion: String?
    @NSManaged var user: NSManagedObject?

}
