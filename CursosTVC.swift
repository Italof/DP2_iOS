//
//  CursosTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CursosTVC: UITableViewController {
    
    @IBOutlet weak var cicloActual: UILabel!
    
    var courseDictionary:Dictionary<Int32,Array<Course>> = Dictionary<Int32,Array<Course>>()
    var courseKeys:Array<Int32> = []
    var faculty:Faculty? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseDictionary = Course.getClassifiedCoursesByLevel(self.faculty!, ctx: globalCtx)!
        self.courseKeys = Array(self.courseDictionary.keys).sort { $0 > $1 }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Nivel " + self.courseKeys[section].description
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.courseKeys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let key = self.courseKeys[section]
        
        return ((self.courseDictionary[key])?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cursoCell", forIndexPath: indexPath)
        
        let key = self.courseKeys[indexPath.section]
        let obj = (self.courseDictionary[key])![indexPath.row]
        
        cell.textLabel?.text = obj.codigo! + " - " + obj.nombre!
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor(red: 232/256, green: 232/256, blue: 232/256, alpha: 0.9)
        label.textColor = UIColor(red: 169/256, green: 169/256, blue: 169/256, alpha: 0.9)
        label.text = "    Resultado Estudiantil " + self.courseKeys[section].description
        label.font = UIFont.boldSystemFontOfSize(17.0)
        return label
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

    @IBAction func unwindSegueOrderCourses (sender: UIStoryboardSegue) {
        
        let sourceViewController = sender.sourceViewController as? SemesterModalViewController
        
        //Add the new address to the client
        //sourceViewController?.objDireccion!.cliente = self.cliente
        
        //Add the new address to the list
        //self.addressList?.append((sourceViewController?.objDireccion)!)
        
        //Reload data
        self.tableView.reloadData()
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "courseDetailSegue" {
            let vc = segue.destinationViewController as! CourseDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let key = self.courseKeys[indexPath!.section]
            vc.course = (self.courseDictionary[key]!)[indexPath!.row]
            
            vc.faculty = self.faculty
        }
        
    }

}
