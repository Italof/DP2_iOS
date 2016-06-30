//
//  Professor.swift
//  
//
//  Created by Karl Montenegro on 07/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let ProfessorIdKey = "IdDocente"
let ProfessorFacultyKey = "IdEspecialidad"
let ProfessorUserKey = "IdUsuario"
let ProfessorCodeKey = "Codigo"
let ProfessorNameKey = "Nombre"
let ProfessorLastNamePKey = "ApellidoPaterno"
let ProfessorLastNameMKey = "ApellidoMaterno"
let ProfessorEmailKey = "Correo"
let ProfessorActiveKey = "Vigente"
let ProfessorDescriptionKey = "Descripcion"
let ProfessorPositionKey = "Cargo"

class Professor: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var codigo: String?
    @NSManaged var nombres: String?
    @NSManaged var apellidos: String?
    @NSManaged var email: String?
    @NSManaged var cargo: String?
    @NSManaged var vigente: NSNumber?
    @NSManaged var descripcion: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var timetable: NSSet?
    @NSManaged var plans: NSSet?
    @NSManaged var suggestions: NSSet?

}

//MARK: Deserialization

extension Professor {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[ProfessorIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[ProfessorFacultyKey].int32Value, ctx: ctx)
        self.codigo = json[ProfessorCodeKey].stringValue
        self.nombres = json[ProfessorNameKey].stringValue
        self.apellidos = json[ProfessorLastNamePKey].stringValue + " " + json[ProfessorLastNameMKey].stringValue
        self.email = json[ProfessorEmailKey].stringValue
        self.cargo = json[ProfessorPositionKey].stringValue
        self.vigente = json[ProfessorActiveKey].boolValue
        self.descripcion = json[ProfessorDescriptionKey].stringValue
        
    }
    
}

//MARK: Core Data

extension Professor {
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<Professor>? {
        
        let persistedProfessors = Professor.getProfessorsByFaculty(fac, ctx: ctx)
        var newStoredProfessors:Array<Professor> = []
        
        for (_,professor):(String, JSON) in json {
            
            let newProfessor = Professor.updateOrCreateWithJson(professor, ctx: ctx)!
            newStoredProfessors.append(newProfessor)
            
        }
        
        let forDeletion = Array(Set(persistedProfessors).subtract(newStoredProfessors))
        
        for professor in forDeletion {
            ctx.deleteObject(professor)
        }

        return newStoredProfessors
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Professor {
        var professor: Professor? = getProfessorById(id, ctx: ctx)
        if (professor == nil) {
            professor = NSEntityDescription.insertNewObjectForEntityForName("Professor", inManagedObjectContext: ctx) as? Professor
            professor!.id = id
        }
        return professor!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Professor? {
        var professor: Professor?
        
        let professorId = json[ProfessorIdKey].int32Value
        
        professor = findOrCreateWithId(professorId, ctx: ctx)
        professor?.setDataFromJson(json, ctx: ctx)
        
        return professor
    }
    
    internal class func getProfessorById(id: Int32, ctx: NSManagedObjectContext) -> Professor? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Professor", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let professors = try! ctx.executeFetchRequest(fetchRequest) as? Array<Professor>
        
        if (professors != nil && professors!.count > 0) {
            return professors![0]
        }
        return nil
    }
    
    internal class func getAllProfessor(ctx: NSManagedObjectContext) -> Array<Professor> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Professor", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let professor = try! ctx.executeFetchRequest(fetchRequest) as? Array<Professor>
        return professor ?? Array<Professor>()
    }
    
    internal class func getProfessorsByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Professor> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Professor", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let professors = try! ctx.executeFetchRequest(fetchRequest) as? Array<Professor>
        return professors ?? Array<Professor>()
    }
}