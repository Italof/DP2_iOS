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

    let array = ["Objetivo Educacional 1", "Objetivo Educacional 2", "Objetivo Educacional 3", "Objetivo Educacional 4"]
    let sem = ["2014-2", "2015-1", "2015-2", "2016-1"]
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint = Connection()
    
    var faculty:Faculty? = nil
    var edObjList:Array<EducationalObjective>? = nil
    
    override func viewWillAppear(animated: Bool) {
        
        self.loadDBWithJSON()
        self.edObjList = TR_Ed_Objective().get(self.faculty!.id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.edObjList = TR_Ed_Objective().get(Int(self.faculty!.id!))
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
        return self.edObjList!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("objEdCell", forIndexPath: indexPath)

        cell.textLabel?.text = "Objetivo Educacional " + (self.edObjList![indexPath.row]).numero!.description
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ciclo: " + self.sem[section]
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
            
        }
    }
    
    func loadDBWithJSON() {
        
        let idFac = self.faculty?.id
        
        Alamofire.request(.GET, self.endpoint.url + "faculties/" + idFac!.description + "/educational-objectives?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    TR_Ed_Objective().store(json, faculty: self.faculty!)
                case .Failure(let error):
                    print(error)
                }
                
        }
    }

}
