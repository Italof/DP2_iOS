//
//  ViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 02/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

let globalCtx : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint: Connection = Connection()
    
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaults.setBool(false, forKey: "offline_session")
        self.defaults.setObject("", forKey: "token")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTapped(sender: AnyObject) {
        
        let user:String = (self.txtUsername?.text)!
        let pass:String = (self.txtPassword?.text)!
          
        
        Alamofire.request(.POST, self.endpoint.url + "authenticate?user=\(user)&password=\(pass)")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    var facultyList : Array<Faculty> = []
                    var count = 0
                    
                    do {
                        self.defaults.setObject(json["token"].stringValue, forKey: "token")
                        try self.defaults.setObject(json["user"].rawData(), forKey: "user")
                        
                    } catch {
                        print(error)
                    }
                    
                    self.getFaculties() {
                        json, error in
                        
                        if error == nil {
                            facultyList = Faculty.syncWithJson(json!, ctx: globalCtx)!
                            try! globalCtx.save()
                            
                            //Saved all faculties
                            
                            for fac in facultyList {

                                self.getObjectives(fac){
                                    json, error in
                                    
                                    if error == nil {
                                        EducationalObjective.syncWithJson(fac, json: json!, ctx: globalCtx)
                                        try! globalCtx.save()
                                    }
                                }
                                self.getStudentResults(fac){
                                    json, error in
                                    
                                    if error == nil {
                                        StudentResult.syncWithJson(fac, json: json!, ctx: globalCtx)
                                        try! globalCtx.save()
                                    }
                                }
                                
                            }
                            self.performSegueWithIdentifier("facultyListSegue", sender: self)
                        }
                    }
                case .Failure(_):
                    self.alertMessage("Usuario/Contrasena incorrectos.", winTitle: "Error")
                }
                
                    
                    /*
                    for fac in facultyList {
                        
                            self.getObjectives(fac){
                                json, error in
                                //DS_Objectives().storeObjectives(json!)
                                
                                //EdObjectiveDataLoader().refresh_objectives(json!)
                            
                                
                            }
                        self.getStudentResults(fac){
                            json, error in
                            StudentResultsDataLoader().refresh_results(json!)
                            
                            
                        }
                        self.getAspects(fac){
                            json, error in
                            AspectDataLoader().refresh_aspects(json!)
                            
                            
                        }
                        self.getCourses(fac){
                            json, error in
                            CourseDataLoader().refresh_courses(json!)
                            
                            
                        }
                        self.getImprovement(fac) {
                            json, error in
                            ImprovementDataLoader().refresh_plans(json!)
                            
                            
                        }
                        self.getSuggestions(fac) {
                            json, error in
                            SuggestionDataLoader().refresh_suggestions(json!)
                            
                        }
                        
                        
                        
                        
                        count += 1
                        if count == facultyList.count {
                            count = 0
                            //self.performSegueWithIdentifier("facultyListSegue", sender: self)
                        }
                    }
                    */
            }
    }
    
    
    @IBAction func offlineTapped(sender: AnyObject) {
        self.defaults.setBool(true, forKey: "offline_session")
        self.performSegueWithIdentifier("facultyListSegue", sender: self)
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Calls
    
    func authenticateUser(user: String, pass: String, completionHandler: (JSON?,NSError?)->()) {
        authenticateUserCall(user, pass: pass, completionHandler: completionHandler)
    }
    
    func authenticateUserCall(user: String, pass: String, completionHandler: (JSON?,NSError?)->()){
        
        Alamofire.request(.POST, self.endpoint.url + "authenticate?user=\(user)&password=\(pass)")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    completionHandler(json, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
            }
        }
    }
    
    func getFaculties(completionHandler: (JSON?, NSError?)->()) {
        getFacultiesCall(completionHandler)
    }
    
    func getObjectives(fac: Faculty, completionHandler: (JSON?, NSError?) -> ()) {
        getObjectivesCall(fac, completionHandler: completionHandler)
    }
    
    func getStudentResults(fac: Faculty, completionHandler: (JSON?, NSError?) -> ()) {
        getStudentResultsCall(fac, completionHandler: completionHandler)
    }
    
    func getAspects(fac: Faculty, completionHandler: (JSON?, NSError?)->()){
        getAspectsCall(fac, completionHandler: completionHandler)
    }
    
    func getCourses(fac: Faculty, completionHandler: (JSON?,NSError?)->()){
        getCoursesCall(fac, completionHandler: completionHandler)
    }
    
    func getImprovement(fac: Faculty, completionHandler: (JSON?,NSError?)->()) {
        getImprovementCall(fac, completionHandler: completionHandler)
    }
    
    func getSuggestions(fac: Faculty, completionHandler: (JSON?,NSError?)->()) {
        getSuggestionsCall(fac, completionHandler: completionHandler)
    }
    
    func getFacultiesCall(completionHandler: (JSON?, NSError?)->()) {
        Alamofire.request(.GET, self.endpoint.url + "faculties?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    completionHandler(json, nil)
                    break
                case .Failure(let error):
                    completionHandler(nil,error)
                }
        }
    }
    
    func getObjectivesCall(fac: Faculty, completionHandler: (JSON?, NSError?) -> ()) {
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/educational-objectives?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    completionHandler(json, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
        }
        
    }
    
    func getStudentResultsCall(fac: Faculty, completionHandler: (JSON?, NSError?)->()) {
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/students-results?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    completionHandler(json, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    func getAspectsCall(fac: Faculty, completionHandler: (JSON?,NSError?)->()){
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/aspects?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
            switch response.result {
            case .Success:
                let json = JSON(data: response.data!)
                completionHandler(json,nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func getCoursesCall(fac: Faculty, completionHandler: (JSON?,NSError?)->()){
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/evaluated_courses", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
            switch response.result {
            case .Success:
                let json = JSON(data: response.data!)
                completionHandler(json, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func getImprovementCall(fac: Faculty, completionHandler: (JSON?,NSError?)->()) {
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/improvement_plans?since=0", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
            switch response.result {
            case .Success:
                let json = JSON(data: response.data!)
                completionHandler(json, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func getSuggestionsCall(fac: Faculty, completionHandler: (JSON?,NSError?)->()){
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/suggestions", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
            switch response.result {
            case .Success:
                let json = JSON(data: response.data!)
                completionHandler(json, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func deleteAll() {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "EducationalObjective")
        fetchRequest.returnsObjectsAsFaults = false
        
        var results : Array<EducationalObjective> = []
        
        do{
            results = try context.executeFetchRequest(fetchRequest) as! Array<EducationalObjective>
        }catch{
            
        }
        
        for managedObject in results {
            context.deleteObject(managedObject)
        }
        
        do{
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    
}

