//
//  ObjetivosEdTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 05/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ObjetivosEdTVC: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    
    var faculty:Faculty? = nil
    var edObjList:Array<EducationalObjective>? = nil
    
    var edObjDictionary:Dictionary<String,Array<EducationalObjective>>? = nil
    var edObjKeys:Array<String>? = nil
    
    override func viewWillAppear(animated: Bool) {
        //self.edObjList = TR_Ed_Objective().get(self.faculty!.id!)
        
        //self.edObjDictionary = TR_Ed_Objective().get(self.faculty!.id!)
        self.edObjKeys = Array(self.edObjDictionary!.keys)
    }
    
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
        return self.edObjKeys!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.edObjDictionary![self.edObjKeys![section]]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("objEdCell", forIndexPath: indexPath)
        
        let key = self.edObjKeys![indexPath.section]
        let obj = (self.edObjDictionary![key])![indexPath.row]
        
        cell.textLabel?.text = "Objetivo Educacional " + obj.numero!.description + ": " + obj.descripcion!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Ciclo " + self.edObjKeys![section]
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
        
        if segue.identifier == "objectiveDetailSegue" {
            let vc = segue.destinationViewController as! EducationalObjectiveDetail
            let indexPath = self.tableView.indexPathForSelectedRow
            
            vc.ed_objective = self.edObjList![(indexPath?.row)!]

        }
    }

}
