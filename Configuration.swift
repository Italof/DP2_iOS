//
//  Configuration.swift
//  
//
//  Created by Karl Montenegro on 01/07/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let ConfigIdKey = "IdConfEspecialidad"
let ConfigAcceptKey = "UmbralAceptacion"
let ConfigExpectLevelKey = "NivelEsperado"
let ConfigCriteriaLevelKey = "CantNivelCriterio"
let ConfigFacultyKey = "IdEspecialidad"
let ConfigPeriodKey = "IdPeriodo"

/*
 "IdConfEspecialidad": 1,
 "IdEspecialidad": "1",
 "IdPeriodo": "1",
 "IdCicloInicio": "1",
 "IdCicloFin": "2",
 "UmbralAceptacion": "70",
 "NivelEsperado": "3",
 "CantNivelCriterio": "4"
 */

class Configuration: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var acceptTreshold: Int32
    @NSManaged var expectedLevel: Int32
    @NSManaged var criteriaLevel: Int32
    @NSManaged var period: Period?
    @NSManaged var semesterStart: Semester?
    @NSManaged var semesterEnd: Semester?
    @NSManaged var faculty: Faculty?

}

//MARK: Deserialization

extension Configuration {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[ConfigIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[ConfigFacultyKey].int32Value, ctx: ctx)
        self.acceptTreshold = json[ConfigAcceptKey].int32Value
        self.expectedLevel = json[ConfigExpectLevelKey].int32Value
        self.criteriaLevel = json[ConfigCriteriaLevelKey].int32Value
        self.period = Period.getPeriodById(json[ConfigPeriodKey].int32Value, ctx: ctx)
    }
    
}

//MARK: - Core Data

extension Configuration {
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Configuration {
        var config: Configuration? = getConfigById(id, ctx: ctx)
        if (config == nil) {
            config = NSEntityDescription.insertNewObjectForEntityForName("Configuration", inManagedObjectContext: ctx) as? Configuration
            config!.id = id
        }
        return config!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> Configuration? {
        var config: Configuration?
        
        let configId = json[ConfigIdKey].int32Value
        
        config = findOrCreateWithId(configId, ctx: ctx)
        config?.setDataFromJson(json, ctx: ctx)
        
        return config
    }
    
    internal class func getConfigById(id: Int32, ctx: NSManagedObjectContext) -> Configuration? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Configuration", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let configs = try! ctx.executeFetchRequest(fetchRequest) as? Array<Configuration>
        
        if (configs != nil && configs!.count > 0) {
            return configs![0]
        }
        return nil
    }
    
    internal class func getAllConfigs(ctx: NSManagedObjectContext) -> Array<Configuration> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Configuration", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let config = try! ctx.executeFetchRequest(fetchRequest) as? Array<Configuration>
        return config ?? Array<Configuration>()
    }
    
    internal class func getConfigsByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<Configuration> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Configuration", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let configs = try! ctx.executeFetchRequest(fetchRequest) as? Array<Configuration>
        return configs ?? Array<Configuration>()
    }
    
}
