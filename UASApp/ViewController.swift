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
let DocumentDirURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint: Connection = Connection()
    
    let dateFormatter = NSDateFormatter()
    var fileManager = NSFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidden = true
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
          
        self.activityIndicator.startAnimating()
        Alamofire.request(.POST, self.endpoint.url + "authenticate?user=\(user)&password=\(pass)")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    var facultyList : Array<Faculty> = []
                    var courseList : Array<Course> = []
                    
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
                                
                                self.getSettingsForApp(fac) {
                                    json, error in
                                    
                                    if error == nil {
                                        Period.syncWithJson(fac, json: json!, ctx: globalCtx)
                                        try! globalCtx.save()
                                        
                                        //MARK: - Educational Objectives
                                        self.getObjectives(fac){
                                            json, error in
                                            
                                            if error == nil {
                                                EducationalObjective.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                try! globalCtx.save()
                                                
                                                //MARK: - Student Results
                                                self.getStudentResults(fac){
                                                    json, error in
                                                    
                                                    if error == nil {
                                                        StudentResult.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                        try! globalCtx.save()
                                                        
                                                        //MARK: - Aspects
                                                        self.getAspects(fac){
                                                            json, error in
                                                            
                                                            if error == nil {
                                                                Aspect.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                                try! globalCtx.save()
                                                                
                                                                //MARK: - Courses
                                                                self.getCourses(fac){
                                                                    json, error in
                                                                    
                                                                    if error == nil {
                                                                        Course.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                                        try! globalCtx.save()
                                                                        
                                                                        courseList = Course.getCoursesByFaculty(fac, ctx: globalCtx)
                                                                        
                                                                        for course in courseList {
                                                                            //MARK: - Course Reports
                                                                            self.getCourseMeasurement(fac, course: course){
                                                                                json, error in
                                                                                
                                                                                if error == nil {
                                                                                    self.reportManager("course_report_" + fac.id.description + "_" + course.id.description , content: json!)
                                                                                }
                                                                            }
                                                                        }
                                                                        
                                                                        //MARK: - Improvement Plans
                                                                        self.getImprovement(fac) {
                                                                            json, error in
                                                                            
                                                                            if error == nil {
                                                                                ImprovementPlan.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                                                try! globalCtx.save()
                                                                                
                                                                                //MARK: - Suggestions
                                                                                self.getSuggestions(fac) {
                                                                                    json, error in
                                                                                    
                                                                                    if error == nil {
                                                                                        Suggestion.syncWithJson(fac, json: json!, ctx: globalCtx)
                                                                                        try! globalCtx.save()
                                                                                        
                                                                                        //MARK: - Final Report
                                                                                        self.getReport(fac){
                                                                                            json, error in
                                                                                            
                                                                                            if error == nil {
                                                                                                self.reportManager("report_faculty_" + fac.id.description, content: json!)
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            self.performSegueWithIdentifier("facultyListSegue", sender: self)
                            self.activityIndicator.stopAnimating()
                        }
                    }
                case .Failure(_):
                    self.activityIndicator.stopAnimating()
                    self.alertMessage("Usuario/Contrasena incorrectos.", winTitle: "Error")
                }
            }
    }

    //File management
    
    func reportManager(fileName: String, content: String){
        
        let fileURL = DocumentDirURL.URLByAppendingPathComponent(fileName).URLByAppendingPathExtension("html")
        do {
            // Write to the file
            try content.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
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
    
    func getFaculties(completionHandler: (JSON?, NSError?)->()) {
        getFacultiesCall(completionHandler)
    }
    
    func getSettingsForApp(fac: Faculty, completionHandler: (JSON?,NSError?)->()) {
        getSettingsForAppCall(fac, completionHandler: completionHandler)
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
    
    func getReport(fac: Faculty, completionHandler: (String?,NSError?)->()){
        getReportCall(fac, completionHandler: completionHandler)
    }
    
    func getCourseMeasurement(fac: Faculty, course: Course, completionHandler: (String?,NSError?)->()){
        getCourseMeasurementCall(fac, course: course, completionHandler: completionHandler)
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
    
    func getSettingsForAppCall(fac: Faculty, completionHandler: (JSON?, NSError?)->()) {
        //52.38.157.8/api/faculties/1/periods/actual/semesters
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/periods/actual/semesters", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
            switch response.result {
            case .Success:
                let json = JSON(data: response.data!)
                completionHandler(json, nil)
                break
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
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
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/improvement_plans", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
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
    
    func getCourseMeasurementCall(fac: Faculty, course: Course, completionHandler: (String?,NSError?)->()) {
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/evaluated_courses/" + course.id.description + "/semesters/1", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseString {
            response in
            switch response.result {
            case .Success:
                let json = response.result.value
                completionHandler(json, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
        
    }
    
    func getReportCall(fac: Faculty, completionHandler: (String?,NSError?)->()){
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + fac.id.description + "/measure_report", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
            .responseString { response in
            switch response.result {
            case .Success:
                let json = response.result.value
                completionHandler(json, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    func getPresentPeriod(fac: Faculty, completionHandler: (JSON?,Error?)->()){
        
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

extension UITableView {
    func indexPathForView (view : UIView) -> NSIndexPath? {
        let location = view.convertPoint(CGPointZero, toView:self)
        return indexPathForRowAtPoint(location)
    }
}

