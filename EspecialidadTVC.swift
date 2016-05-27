//
//  EspecialidadTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 04/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import SwiftyJSON


class EspecialidadTVC: UITableViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    
    var facultyList:Array<Faculty> = Faculty.MR_findAll() as! Array<Faculty>
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources thavaran be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.facultyArray!.count
        return self.facultyList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facultyCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.facultyList[indexPath.row].nombre
        return cell
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction func logoutTapped(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Atención", message:
            "¿Desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            // Logs out
            self.performSegueWithIdentifier("logoutSegue", sender: sender)
        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in

        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentMainMenuSegue" {
            let splitViewController:MasterSVC = segue.destinationViewController as! MasterSVC
            
            let indexpath = self.tableView.indexPathForSelectedRow
            
            
            splitViewController.faculty = self.facultyList[indexpath!.row]
            
            
            print(self.facultyList[indexpath!.row].nombre)
            
            //splitViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        }
        
        if segue.identifier == "logoutSegue" {
            
        }
    }
    
}
