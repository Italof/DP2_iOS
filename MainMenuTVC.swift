//
//  MainMenuTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 05/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol dataReceiveForMenu {
    func acceptData(faculty: Faculty)
}

class MainMenuTVC: UITableViewController, UISplitViewControllerDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    @IBOutlet weak var userSpecialty: UILabel!
    @IBOutlet weak var facultyName: UILabel!
    
    var faculty:Faculty? = nil
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    var userJSON:JSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userJSON = JSON(data: self.defaults.objectForKey("user") as! NSData)
        
        
        self.facultyName.text = self.faculty?.nombre
        
        if self.userJSON!["professor"] != nil {
            let info = self.userJSON!["professor"]
            self.userFullName.text = info["Nombre"].stringValue + " " + info["Apellido Materno"].stringValue + " " + info["ApellidoPaterno"].stringValue
            self.userPosition.text = "Profesor"
            
        } else {
            if self.userJSON!["coordinador"] != nil {
                
                let info = self.userJSON!["coordinador"]
                self.userFullName.text = info["Nombre"].stringValue + " " + info["Apellido Materno"].stringValue + " " + info["ApellidoPaterno"].stringValue
                self.userPosition.text = "Coordinador"
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 1: //Inicio
                    self.performSegueWithIdentifier("startSegue", sender: self)
                    break
            case 2: //Facultades
                    self.performSegueWithIdentifier("facultiesMenuSegue", sender: self)
                    break
            
            case 3: //Obj. Educacionales
                
                    Alamofire.request(.GET, self.endpoint.url + "faculties/" + (self.faculty?.id!.description)! + "/educational-objectives?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
                        .responseJSON { response in
                        switch response.result {
                            case .Success:
                                let json = JSON(data: response.data!)
                                EdObjectiveDataLoader().refresh_objectives(json)
                                self.performSegueWithIdentifier("edObjectivesSegue", sender: self)
                            case .Failure(let error):
                            print(error)
                        }
                    }
                
                    break
            case 4: //Res. Estudiantiles
                
                Alamofire.request(.GET, self.endpoint.url + "faculties/" + (self.faculty?.id!.description)! + "/students-results?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            let json = JSON(data: response.data!)
                            
                            StudentResultsDataLoader().refresh_results(json)
                            self.performSegueWithIdentifier("studentResSegue", sender: self)
                        case .Failure(let error):
                            print(error)
                        }
                }
                break
            case 5: //Aspectos
                
                Alamofire.request(.GET, self.endpoint.url + "faculties/" + (self.faculty?.id!.description)! + "/aspects?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
                    switch response.result {
                        case .Success:
                            let json = JSON(data: response.data!)
                            AspectDataLoader().refresh_aspects(json)
                            self.performSegueWithIdentifier("aspectSegue", sender: self)
                        case .Failure(let error):
                            print(error)
                    }
                    
                }
                    break

            case 6: //Cursos
                
                Alamofire.request(.GET, self.endpoint.url + "faculties/" + (self.faculty?.id!.description)! + "/evaluated_courses", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
                    switch response.result {
                    case .Success:
                        let json = JSON(data: response.data!)
                            CourseDataLoader().refresh_courses(json)
                        self.performSegueWithIdentifier("coursesSegue", sender: self)
                    case .Failure(let error):
                        print(error)
                    }
                    
                }
                    break
            case 7: //Mejora Continua
                
                Alamofire.request(.GET, self.endpoint.url + "faculties/" + (self.faculty?.id!.description)! + "/improvement_plans?since=0", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)]).responseJSON { response in
                    switch response.result {
                    case .Success:
                        let json = JSON(data: response.data!)
                        ImprovementDataLoader().refresh_plans(json)
                        self.performSegueWithIdentifier("improvementSegue", sender: self)
                    case .Failure(let error):
                        print(error)
                    }
                    
                }
                
                    break
            case 8: //Resultados de Evaluaciones
                
                    break
            case 10: //Cerrar Sesion
                let alertController = UIAlertController(title: "Atención", message:
                    "¿Desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.Alert)
                
                // Delete action
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                    // Logs out
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    self.performSegueWithIdentifier("logout", sender: self)
                }))
                
                // Cancel action
                alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                    break
            default: break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSegue" {
            
        }
        
        if segue.identifier == "facultiesMenuSegue" {
            
        }
        
        if segue.identifier == "edObjectivesSegue" {
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.viewControllers.first as! ObjetivosEdTVC
            vc.faculty = self.faculty
        }
        
        if segue.identifier == "studentResSegue" {
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.viewControllers.first as! ResEdTVC
            vc.faculty = self.faculty
        }
        
        if segue.identifier == "aspectSegue"{
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.viewControllers.first as! AspectosTVC
            vc.faculty = self.faculty
            
        }
        
        if segue.identifier == "coursesSegue" {
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.viewControllers.first as! CursosTVC
            vc.faculty = self.faculty
        }
        
        if segue.identifier == "improvementSegue" {
            let nvc = segue.destinationViewController as! UITabBarController
            let vc = nvc.viewControllers![0]
            
            //let suggestions = vc.childViewControllers[1] as! Suggestions
            let improvementPlans = vc.childViewControllers.first as! ImprovementPlans
            
            //suggestions.faculty = self.faculty
            improvementPlans.faculty = self.faculty
            
        }
        
    }

}
