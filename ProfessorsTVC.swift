//
//  ProfessorsTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 09/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class ProfessorsTVC: UITableViewController {

    var timetable: Timetable? = nil
    var professors: Array<Professor> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.professors = Professor.getProfessorsByTimetable(self.timetable!, ctx: globalCtx)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.professors.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath)

        let professor = self.professors[indexPath.row]
        
        cell.textLabel?.text = professor.codigo
        cell.detailTextLabel?.text = (professor.nombres)! + " " + (professor.apellidos)!

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
        
        if segue.identifier == "professorDetailSegue" {
            let vc = segue.destinationViewController as! TeacherModal
            let indexPath = self.tableView.indexPathForSelectedRow
            vc.professor = self.professors[indexPath!.row]
            
        }
    }

}
