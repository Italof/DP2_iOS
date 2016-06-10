//
//  CursosTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CursosTVC: UITableViewController {
    
    var courseDictionary:Dictionary<NSNumber,Array<Course>>? = nil
    var courseKeys:Array<NSNumber>? = nil
    var faculty:Faculty? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseDictionary = CourseDataLoader().get_all(self.faculty!)
        self.courseKeys = Array(self.courseDictionary!.keys)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Nivel " + self.courseKeys![section].description
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.courseKeys!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let key = self.courseKeys![section]
        
        return ((self.courseDictionary![key])?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cursoCell", forIndexPath: indexPath)
        
        let key = self.courseKeys![indexPath.section]
        let obj = (self.courseDictionary![key])![indexPath.row]
        
        cell.textLabel?.text = obj.codigo! + " - " + obj.nombre!
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
        
        if segue.identifier == "courseDetailSegue" {
            let tvc = segue.destinationViewController as! CursoDetalleTVC
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let key = self.courseKeys![indexPath!.section]
            tvc.course = (self.courseDictionary![key]!)[indexPath!.row]
            
            tvc.faculty = self.faculty
        }
        
    }

}
