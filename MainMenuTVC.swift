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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            case 2: //Obj. Educacionales
                    self.performSegueWithIdentifier("edObjectivesSegue", sender: self)
                    break
            case 3: //Res. Estudiantiles
                    self.performSegueWithIdentifier("studentResSegue", sender: self)
                    break
            case 4: //Rubricas
                    self.performSegueWithIdentifier("rubricSegue", sender: self)
                    break
            case 5: //Aspectos
                    self.performSegueWithIdentifier("aspectSegue", sender: self)
                    break

            case 6: //Cursos
                    self.performSegueWithIdentifier("coursesSegue", sender: self)
                    break
            case 7: //Mejora Continua
                    self.performSegueWithIdentifier("improvementSegue", sender: self)
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
