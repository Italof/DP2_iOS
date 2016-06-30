//
//  CourseDetailViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 30/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var courseTitle: UINavigationItem!
    @IBOutlet weak var codigo: UILabel!
    @IBOutlet weak var nivel: UILabel!
    @IBOutlet weak var especialidad: UILabel!
    
    var faculty : Faculty?
    var course : Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseTitle.title = self.course?.nombre
        self.codigo.text = self.course!.codigo
        self.nivel.text = self.course!.nivelAcademico.description
        self.especialidad.text = self.faculty?.nombre
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
        return 2
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timetableCell", forIndexPath: indexPath)
        
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
