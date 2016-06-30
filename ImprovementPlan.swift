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
let PlanDescriptionKey = "Descripcion"
let PlanTypeDataKey = "type_improvement_plan"
let PlanProfessorDataKey = "teacher"


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
        
        for (_,plan):(String, JSON) in json {
            
            let newPlan = ImprovementPlan.updateOrCreateWithJson(plan, ctx: ctx)!
            newStoredPlans.append(newPlan)
            
            let newType = PlanType.updateOrCreateWithJson(plan[PlanTypeDataKey], ctx: ctx)!
            newPlan.planType = newType
            
            let newProfessor = Professor.updateOrCreateWithJson(plan[PlanProfessorDataKey], ctx: ctx)!
            newPlan.professor = newProfessor
            
        }
        
        let forDeletion = Array(Set(persistedPlans).subtract(newStoredPlans))
        
        for plan in forDeletion {
            ctx.deleteObject(plan)
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


