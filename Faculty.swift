//
//  Faculty.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let FacultyIdKey = "IdEspecialidad"
let FacultyCodeKey = "Codigo"
let FacultyNameKey = "Nombre"
let FacultyDescriptionKey = "Descripcion"
let FacultyUpdateKey = "updated_at"
let FacultyTeacherKey = "IdDocente"
let FacultyCoordinatorKey = "coordinator"

class Faculty: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var nombre: String?
    @NSManaged var codigo: String?
    @NSManaged var descripcion: String?
    @NSManaged var educationalObjective: NSSet?
    @NSManaged var course: NSSet?
    @NSManaged var studentResult: NSSet?
    @NSManaged var suggestion: NSSet?
    @NSManaged var improvementPlan: NSSet?
    @NSManaged var criterion: NSSet?
    @NSManaged var timetable: NSSet?
    @NSManaged var professor: NSSet?
    @NSManaged var planTypes: NSSet?
    @NSManaged var coordinator: Coordinator?
    @NSManaged var aspects: NSSet?

}

// MARK - Deserialization

extension Faculty {
    
    func setDataFromJson(json: JSON) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[FacultyIdKey].int32Value
        self.nombre = json[FacultyNameKey].stringValue
        self.descripcion = json[FacultyDescriptionKey].stringValue
        self.codigo = json[FacultyCodeKey].stringValue
        self.updated_at = dateFormatter.dateFromString(json[FacultyUpdateKey].stringValue)
        
    }
}

//MARK - Core Data 

extension Faculty {
    internal class func syncWithJson(json: JSON, ctx: NSManagedObjectContext)->Array<Faculty>? {
        
        let persistedFaculties = Faculty.getAllFaculties(ctx)
        var newStoredFaculties:Array<Faculty> = []
        
        for (_,faculty):(String, JSON) in json {
            newStoredFaculties.append(Faculty.updateOrCreateWithJson(faculty, ctx: ctx)!)
        }
        
        let forDeletion = Array(Set(persistedFaculties).subtract(newStoredFaculties))
        
        for faculty in forDeletion {
            ctx.deleteObject(faculty)
        }
        
        return newStoredFaculties
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Faculty {
        var faculty: Faculty? = getFacultyById(id, ctx: ctx)
        if (faculty == nil) {
            faculty = NSEntityDescription.insertNewObjectForEntityForName("Faculty", inManagedObjectContext: ctx) as? Faculty
            faculty!.id = id
        }
        return faculty!
    }
    
    private class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Faculty? {
        var faculty: Faculty?
        
        let facultyId = json[FacultyIdKey].int32Value
        
        faculty = findOrCreateWithId(facultyId, ctx: ctx)
        faculty?.setDataFromJson(json)
        
        return faculty
    }
    
    internal class func getFacultyById(id: Int32, ctx: NSManagedObjectContext) -> Faculty? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Faculty", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let faculties = try! ctx.executeFetchRequest(fetchRequest) as? Array<Faculty>
        
        if (faculties != nil && faculties!.count > 0) {
            return faculties![0]
        }
        return nil
    }
    
    internal class func getAllFaculties(ctx: NSManagedObjectContext) -> Array<Faculty> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Faculty", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let faculties = try! ctx.executeFetchRequest(fetchRequest) as? Array<Faculty>
        return faculties ?? Array<Faculty>()
    }
    
}


/*
{
    "IdEspecialidad": 1,
    "Codigo": "INF",
    "Nombre": "Ingeniería Informática",
    "Descripcion": "Tendrás una excelente base tecnológica y científica para la automatización de la información en cualquier organización.",
    "deleted_at": null,
    "created_at": "2016-06-18 05:00:00",
    "updated_at": "2016-06-18 17:29:10",
    "IdDocente": "1",
    "coordinator": null
}*/