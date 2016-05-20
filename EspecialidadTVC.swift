//
//  EspecialidadTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 04/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import Alamofire

class EspecialidadTVC: UITableViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    let transactor = FacultyTransactions()
    
    var facultyArray: Array<Faculty>? = nil
    
    override func viewWillAppear(animated: Bool) {
        self.facultyArray = self.requestFaculties()!
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.facultyArray!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facultyCell", forIndexPath: indexPath)

        var faculty = self.facultyArray![indexPath.row]
        
        cell.textLabel?.text = faculty.nombre
        cell.detailTextLabel?.text = faculty.descripcion

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
    @IBAction func logoutTapped(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Atención", message:
            "¿Desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Delete action
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            // Logs out
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in

        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentMainMenuSegue" {
            let mainSVC = segue.destinationViewController as! UISplitViewController
            
            mainSVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        }
        
        if segue.identifier == "logoutSegue" {
            
        }
    }
    
    //Server Requests
    
    func requestFaculties() -> Array<Faculty>?{
        
        let token = self.defaults.objectForKey("token")!
        
        Alamofire.request(.GET, self.endpoint.url + "faculties?since=1463183832&token=\(token)")
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    self.transactor.loadFaculties(JSON as? [AnyObject])
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        return self.transactor.all()
    }
}
