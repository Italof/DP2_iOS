//
//  EducationalObjectiveDetailViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 23/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EducationalObjectiveDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var nroObjetivo: UILabel!
    @IBOutlet weak var estado: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    
    @IBOutlet weak var resultList: UITableView!

    var educationalObjective : EducationalObjective?
    var resultListArray : Array<StudentResult> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultListArray = self.educationalObjective!.studentResults?.allObjects as! Array<StudentResult>
        
        self.nroObjetivo.text = self.educationalObjective?.numero.description
        
        if self.educationalObjective?.estado! == 1 {
            self.estado.text = "Activo"
            self.estado.textColor = UIColor.init(red: 76/256, green: 137/256, blue: 44/256, alpha: 0.9)
        } else {
            self.estado.text = "Inactivo"
            self.estado.textColor = UIColor.redColor()

        }
        
        self.descripcion.text = self.educationalObjective?.descripcion
        
        // Do any additional setup after loading the view.
        
        self.resultList.emptyDataSetSource = self;
        self.resultList.emptyDataSetDelegate = self;
        
        self.resultList.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Empty Data Set Configuration
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No hay Resultados Educacionales"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "La especialidad no ha registrado resultados educacionales"
        
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Empty_Result_Placeholder")
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultListArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("objEdCell", forIndexPath: indexPath)
        
        var imageView : UIImageView
        var imageName : String = ""
        imageView  = UIImageView(frame:CGRectMake(20, 20, 30, 30))
        let res = self.resultListArray[indexPath.row]
        
        if (res.estado?.boolValue)! {
            imageName = "Green-Circle-30"
        } else {
            imageName = "Red-Circle-30"
        }
        
        imageView.image = UIImage(named: imageName)
        
        cell.textLabel?.text = "Resulado " + self.resultListArray[indexPath.row].identificador!
        cell.detailTextLabel?.text = self.resultListArray[indexPath.row].descripcion
        cell.accessoryView = imageView
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
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
