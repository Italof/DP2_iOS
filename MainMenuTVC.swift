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
                
                    break
            case 5: //Aspectos
                
                    break

            case 6: //Cursos
                
                    break
            case 7: //Mejora Continua
                
                    break
            case 8: //Resultados de Evaluaciones
                
                    break
            case 10: //Cerrar Sesion

                    break
            default: break
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! UITableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if segue.identifier == "edObjectivesSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! UITableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if segue.identifier == "studentResSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! UITableViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}
