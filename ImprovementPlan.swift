//
//  ImprovementPlan.swift
//  
//
//  Created by Karl Montenegro on 10/06/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

let PlanIdKey =  "IdPlanMejora"
let PlanTypeKey = "IdTipoPlanMejora"
let PlanFacultyKey = "IdEspecialidad"
let PlanProfessorKey = "IdDocente"
let PlanDateKey = "FechaImplementacion"
let PlanAnalisysKey = "AnalisisCausal"
let PlanDescriptionKey = "Mejor nivel en exposiciones"
let PlanTypeDataKey = "type_improvement_plan"
let PlanProfessorDataKey = "teacher"

/*
 {
 "IdPlanMejora": 2,
 "IdTipoPlanMejora": "2",
 "IdEspecialidad": "1",
 "IdArchivoEntrada": "5",
 "IdDocente": "1",
 "Identificador": null,
 "AnalisisCausal": "Falta de habilidades blandas",
 "Hallazgo": "Se detectó un nivel deficiente en exposiciones",
 "Descripcion": "Mejor nivel en exposiciones",
 "FechaImplementacion": "2016-06-30 00:00:00",
 "Estado": "Pendiente",
 "deleted_at": null,
 "created_at": "2016-06-24 16:26:31",
 "updated_at": "2016-06-24 20:08:54",
 "file_url": "",
 "type_improvement_plan": {
 "IdTipoPlanMejora": 2,
 "IdEspecialidad": "1",
 "Codigo": "SOUT-L",
 "Tema": "Resultados Estudiante",
 "Descripcion": "Gestión de proyectos",
 "deleted_at": null,
 "created_at": "2016-05-27 21:56:00",
 "updated_at": "2016-05-27 21:56:00"
 },
 "teacher": {
 "IdDocente": 1,
 "IdEspecialidad": "1",
 "IdUsuario": "2",
 "Codigo": "19960275",
 "Nombre": "Luis Alberto",
 "ApellidoPaterno": "Flores",
 "ApellidoMaterno": "García",
 "Correo": " luis.flores@pucp.edu.pe",
 "Cargo": "Profesor Contratado",
 "Vigente": "1",
 "Descripcion": "Ingeniería de Software, Gestión de Proyectos, Gestión de Procesos\r\nIngeniería de Software  ",
 "deleted_at": null,
 "created_at": "2016-06-18 17:24:00",
 "updated_at": "2016-06-18 17:24:00"
 }
 */


class ImprovementPlan: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var updated_at: NSDate?
    @NSManaged var analisisCausal: String?
    @NSManaged var hallazgo: String?
    @NSManaged var descripcion: String?
    @NSManaged var fechaImplementacion: NSDate?
    @NSManaged var estado: String?
    @NSManaged var faculty: Faculty?
    @NSManaged var planType: PlanType?
    @NSManaged var professor: Professor?
    @NSManaged var suggestions: NSSet?

}

//MARK: -Deserialization

extension ImprovementPlan {
    
    func setDataFromJson(json: JSON, ctx: NSManagedObjectContext){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        self.id = json[PlanIdKey].int32Value
        self.faculty = Faculty.getFacultyById(json[PlanFacultyKey].int32Value, ctx: ctx)
        self.planType = PlanType.getTypeById(json[PlanTypeKey].int32Value, ctx: ctx)
        self.descripcion = json[PlanDescriptionKey].stringValue
        self.professor = Professor.getProfessorById(json[PlanProfessorKey].int32Value, ctx: ctx)
        self.fechaImplementacion = dateFormatter.dateFromString(json[PlanDateKey].stringValue)
        self.analisisCausal = json[PlanAnalisysKey].stringValue
        
    }
    
}

//MARK: -Core Data

extension ImprovementPlan {
    internal class func syncWithJson(fac: Faculty, json: JSON, ctx: NSManagedObjectContext)->Array<ImprovementPlan>? {
        
        let persistedPlans = ImprovementPlan.getPlansByFaculty(fac, ctx: ctx)
        var newStoredPlans:Array<ImprovementPlan> = []
        
        for plan in persistedPlans {
            ctx.deleteObject(plan)
        }
        
        for (_,plan):(String, JSON) in json {
            
            let newPlan = ImprovementPlan.updateOrCreateWithJson(plan, ctx: ctx)!
            newStoredPlans.append(newPlan)
            
            let newType = PlanType.updateOrCreateWithJson(plan[PlanTypeDataKey], ctx: ctx)!
            newPlan.planType = newType
            
            let newProfessor = Professor.updateOrCreateWithJson(plan[PlanProfessorDataKey], ctx: ctx)!
            newPlan.professor = newType
            
        }
        
        return newStoredPlans
    }
    
    private class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> ImprovementPlan {
        var plan: ImprovementPlan? = getPlanById(id, ctx: ctx)
        if (plan == nil) {
            plan = NSEntityDescription.insertNewObjectForEntityForName("ImprovementPlan", inManagedObjectContext: ctx) as? ImprovementPlan
            plan!.id = id
        }
        return plan!
    }
    
    internal class func updateOrCreateWithJson(json: JSON, ctx: NSManagedObjectContext) -> ImprovementPlan? {
        var plan: ImprovementPlan?
        
        let planId = json[PlanIdKey].int32Value
        
        plan = findOrCreateWithId(planId, ctx: ctx)
        plan?.setDataFromJson(json, ctx: ctx)
        
        return plan
    }
    
    internal class func getPlanById(id: Int32, ctx: NSManagedObjectContext) -> ImprovementPlan? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("ImprovementPlan", inManagedObjectContext: ctx)
        fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
        
        let plans = try! ctx.executeFetchRequest(fetchRequest) as? Array<ImprovementPlan>
        
        if (plans != nil && plans!.count > 0) {
            return plans![0]
        }
        return nil
    }
    
    internal class func getAllPlans(ctx: NSManagedObjectContext) -> Array<ImprovementPlan> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("ImprovementPlan", inManagedObjectContext: ctx)
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let plan = try! ctx.executeFetchRequest(fetchRequest) as? Array<ImprovementPlan>
        return plan ?? Array<ImprovementPlan>()
    }
    
    internal class func getPlansByFaculty(fac: Faculty, ctx: NSManagedObjectContext) -> Array<ImprovementPlan> {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("ImprovementPlan", inManagedObjectContext: ctx)
        let predicate = NSPredicate(format: "(faculty = %@)", fac)
        let sortDescriptor = NSSortDescriptor(key: "fechaImplementacion", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let plans = try! ctx.executeFetchRequest(fetchRequest) as? Array<ImprovementPlan>
        return plans ?? Array<ImprovementPlan>()
    }
}


