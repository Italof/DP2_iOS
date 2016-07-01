//
//  StudentResultDetailViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 30/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class StudentResultDetailViewController: UIViewController {

    var studentResult: StudentResult? = nil
    var parentObjectives: Array<EducationalObjective> = []
    
    @IBOutlet weak var resultTitle: UINavigationItem!
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var resultDescription: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTitle.title = "Resultado Estudiantil " + self.studentResult!.identificador!
        self.identifier.text = self.studentResult!.identificador
        self.resultDescription.text = self.studentResult!.descripcion
        
        self.parentObjectives = EducationalObjective.getObjectivesByResult(self.studentResult!, ctx: globalCtx)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.parentObjectives.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("resEdCell", forIndexPath: indexPath)
        
        let obj = self.parentObjectives[indexPath.row]
        
        var imageView : UIImageView
        var imageName : String = ""
        imageView  = UIImageView(frame:CGRectMake(20, 20, 30, 30))
        
        if obj.estado != nil {
            if (obj.estado?.boolValue)! {
                imageName = "Active-Circle-30"
            } else {
                imageName = "Inactive-Circle-30"
            }
        }
        
        imageView.image = UIImage(named: imageName)
        
        cell.textLabel?.text = "Objetivo Educacional " + obj.numero.description
        cell.detailTextLabel?.text = obj.descripcion
        cell.accessoryView = imageView
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
