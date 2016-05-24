//
//  MainMenuTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 05/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class MainMenuTVC: UITableViewController, UISplitViewControllerDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    @IBOutlet weak var userSpecialty: UILabel!
    @IBOutlet weak var facultyName: UILabel!
    
    var faculty: Faculty? = nil
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.faculty)
        self.userSpecialty.text = self.faculty?.nombre
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
                    self.performSegueWithIdentifier("edObjectivesSegue", sender: self)
                    break
            case 4: //Res. Estudiantiles
                    self.performSegueWithIdentifier("studentResSegue", sender: self)
                    break
            case 5: //Rubricas
                    self.performSegueWithIdentifier("rubricSegue", sender: self)
                    break
            case 6: //Aspectos
                    self.performSegueWithIdentifier("aspectSegue", sender: self)
                    break

            case 7: //Cursos
                    self.performSegueWithIdentifier("coursesSegue", sender: self)
                    break
            case 8: //Mejora Continua
                    self.performSegueWithIdentifier("improvementSegue", sender: self)
                    break
            case 9: //Resultados de Evaluaciones
                
                    break
            case 11: //Cerrar Sesion
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
           
        }
        
        if segue.identifier == "studentResSegue" {
            
        }
        
        if segue.identifier == "rubricSegue" {
            
        }
        
        if segue.identifier == "aspectSegue"{
            
        }
        
        if segue.identifier == "coursesSegue" {
            
        }
        
        if segue.identifier == "improvementSegue" {
            
        }
        
    }

}
