//
//  AspectosTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class AspectosTVC: UITableViewController {
    
    var faculty: Faculty? = nil
    var aspects: Array<Aspect> = []
    var aspectDictionary = Dictionary<String,Array<Aspect>>()
    var aspectKeys : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aspectDictionary = Aspect.getClassifiedAspectsByResult(self.faculty!, ctx: globalCtx)!
        self.aspectKeys = Array(self.aspectDictionary.keys).sort()
        self.aspects = Aspect.getAllAspects(globalCtx)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.aspectKeys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = self.aspectKeys[section]
        
        return (self.aspectDictionary[key]?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aspectCell", forIndexPath: indexPath)
        
        let key = self.aspectKeys[indexPath.section]
        let aspect = (self.aspectDictionary[key])![indexPath.row]
        
        var imageView : UIImageView
        var imageName : String = ""
        imageView  = UIImageView(frame:CGRectMake(20, 20, 30, 30))
        
        if (aspect.estado != nil) {
            
            if (aspect.estado?.boolValue)! {
                imageName = "Green-Circle-30"
            } else {
                imageName = "Red-Circle-30"
            }
        }
        
        imageView.image = UIImage(named: imageName)
        cell.textLabel?.text = aspect.nombre
        cell.accessoryView = imageView
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label : UILabel = UILabel()
        label.backgroundColor = UIColor(red: 232/256, green: 232/256, blue: 232/256, alpha: 0.9)
        label.textColor = UIColor(red: 169/256, green: 169/256, blue: 169/256, alpha: 0.9)
        label.text = "    Resultado Estudiantil " + self.aspectKeys[section]
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "aspectDetailSegue" {
            let vc = segue.destinationViewController as! AspectoDetailTVC
            let indexPath = self.tableView.indexPathForSelectedRow
            
            vc.aspecto = self.aspects[indexPath!.row]
            //vc.faculty = self.faculty
        }
        
    }

}
