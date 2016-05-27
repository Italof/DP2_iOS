//
//  EducationalObjectiveDetail.swift
//  UASApp
//
//  Created by Karl Montenegro on 05/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class EducationalObjectiveDetail: UITableViewController {

    var objData = ["1","2015-1","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]
    var arrayRes = ["Resultado Estudiantil 1","Resultado Estudiantil 2","Resultado Estudiantil 3"]
    
    
    var ed_objective: EducationalObjective? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3 {
            return (self.ed_objective?.studentResults?.count)!
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            if section == 1 {
                return ""
            } else {
                if section == 2 {
                    return "Descripción"
                } else {
                    return "Resultados Estudiantiles Asociados"
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 105.0
        } else {
            return 61.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Nro:"
            cell.detailTextLabel?.text = self.ed_objective?.numero?.description
            return cell
        }else {
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Ciclo de Registro"
                cell.detailTextLabel?.text = self.ed_objective?.cicloReg
                return cell
            } else {
                if indexPath.section == 2 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! DescriptionCell
                    cell.lblDescription.text = self.ed_objective?.descripcion
                    
                    return cell
                    
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath)

                    cell.textLabel?.text = "Resultado Educacional: " + (self.ed_objective?.studentResults?.allObjects[indexPath.row] as! StudentResult).identificador!
                    return cell
                }
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "studentResultViewSegue" {
            let vc = segue.destinationViewController as! ResEdDetalleTVC
            
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if indexPath!.section > 2 {
                vc.studentResult = self.ed_objective!.studentResults!.allObjects[(indexPath?.row)!] as? StudentResult
            }
        }
        
    }

}
