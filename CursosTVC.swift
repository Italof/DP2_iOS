//
//  CursosTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CursosTVC: UITableViewController {

    var niveles = ["Nivel 1","Nivel 2","Nivel 3","Nivel 4"]
    
    var c1 = ["IEE222 - Ing. de Software"]
    var c2 = ["IEE256 - Teoria de Comunicaciones"]
    var c3 = ["IEE245 - Desarrollo de Programas 1"]
    var c4 = ["IEE124 - Ing. de Sistemas 1"]
    
    var courseDictionary:Dictionary<NSNumber,Array<Course>>? = nil
    var courseKeys:Array<NSNumber>? = nil
    var faculty:Faculty? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseDictionary = TR_Courses().get(self.faculty!.id!)
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
        /*
        if section == 0 {
            return self.c1.count
        } else {
            if section == 1 {
                return self.c2.count
            } else {
                if section == 2 {
                    return self.c3.count
                } else {
                    if section == 3 {
                        return self.c4.count
                    } else {
                        return 0
                    }
                }
            }
        }
         */
        
        return (self.courseDictionary![section]?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cursoCell", forIndexPath: indexPath)
        /*
        if indexPath.section == 0 {
            cell.textLabel?.text = self.c1[indexPath.row]
        } else {
            if indexPath.section == 1 {
               cell.textLabel?.text = self.c2[indexPath.row]
            } else {
                if indexPath.section == 2 {
                    cell.textLabel?.text = self.c3[indexPath.row]
                } else {
                    if indexPath.section == 3 {
                        cell.textLabel?.text = self.c4[indexPath.row]
                    }
                }
            }
        }
         */
        
        let key = self.courseKeys![indexPath.section]
        let reg = (self.courseDictionary![key]!)[indexPath.row]
        
        cell.textLabel?.text = reg.codigo! + " - " + reg.nombre!
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
