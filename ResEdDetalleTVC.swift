//
//  ResEdDetalleTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class ResEdDetalleTVC: UITableViewController {

    let objEd = ["Objetivo Educacional 1","Objetivo Educacional 2","Objetivo Educacional 3"]
    
    var studentResult: StudentResult? = nil
    
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
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            if section == 4 {
                return self.objEd.count
            } else {
                return 1
            }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Descripción:"
        } else {
            if section == 3 {
                return "Objetivos Educacionales Asociados al Resultado:"
            } else {
                return ""
                }
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 107.0
        } else {
            return 57.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("resEdCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Identificador:"
            cell.detailTextLabel?.text = self.studentResult?.identificador
            return cell
        } else {
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("resEdCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Ciclo de Registro:"
                cell.detailTextLabel?.text = self.studentResult?.cicloRegistro
                return cell
            } else {
                if indexPath.section == 2 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! EdResultDescriptionCell
                    
                    cell.lblDescription.text = self.studentResult?.descripcion
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("resEdCell", forIndexPath: indexPath)
                    cell.textLabel?.text = self.objEd[indexPath.row]
                    cell.detailTextLabel?.text = ""
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
