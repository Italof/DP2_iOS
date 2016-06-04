//
//  CursoDetalleTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CursoDetalleTVC: UITableViewController {


    @IBOutlet weak var courseTitle: UINavigationItem!
    
    var data = ["IEE256","Ing. Informatica","8"]
    
    var p1 = ["Andrés Melgar","19950102"]
    var p2 = ["Ronny Cueva","20012992"]
    
    var course:Course? = nil
    var faculty:Faculty? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseTitle.title = self.course?.nombre
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Profesores Asociados al Cursos"
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 184.0
        } else {
            return 112.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! CursoCell
            cell.lblCodigoCurso.text = self.course?.codigo
            cell.lblNivelCurso.text = self.course?.nivel?.description
            cell.lblEspecialidadCurso.text = self.faculty?.nombre
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("teacherCell", forIndexPath: indexPath) as! TeacherCell
            
            if indexPath.row == 0 {
                cell.lblCodigoProf.text = self.p1[0]
                cell.lblNombreProfesor.text = self.p1[1]
            } else {
                cell.lblNombreProfesor.text = self.p2[1]
                cell.lblCodigoProf.text = self.p2[0]
            }
            
            return cell
        }
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
