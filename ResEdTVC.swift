//
//  ResEdTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class ResEdTVC: UITableViewController {

    let array = ["Resultado Estudiantil 1","Resultado Estudiantil 2","Resultado Estudiantil 3","Resultado Estudiantil 4"]
    
    let sem = ["2014-2", "2015-1", "2015-2", "2016-1"]
    
    var faculty:Faculty? = nil
    
    var studentResDictionary:Dictionary<String,Array<StudentResult>>? = nil
    var studentResKeys:Array<String>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.studentResDictionary = TR_StudentResults().get(self.faculty!.id!)
        self.studentResKeys = Array(self.studentResDictionary!.keys)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.studentResKeys!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.studentResDictionary![self.studentResKeys![section]]!.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ciclo " + self.studentResKeys![section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resCell", forIndexPath: indexPath)

        let key = self.studentResKeys![indexPath.section]
        let res = self.studentResDictionary![key]
        
        cell.textLabel?.text = "Resultado " + res![indexPath.row].identificador!

        return cell
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
        
        if segue.identifier == "educationalResultSegue" {
            let vc = segue.destinationViewController as! ResEdDetalleTVC
            
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let key = self.studentResKeys![(indexPath?.section)!]
            
            vc.studentResult = (self.studentResDictionary![key])![indexPath!.row]
        }
    }

}
