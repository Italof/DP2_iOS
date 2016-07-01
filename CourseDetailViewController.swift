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
    @IBOutlet weak var timetableTableView: UITableView!
    
    var faculty : Faculty?
    var course : Course?
    var timetables : Array<Timetable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseTitle.title = self.course?.nombre
        self.codigo.text = self.course!.codigo
        self.nivel.text = self.course!.nivelAcademico.description
        self.especialidad.text = self.faculty?.nombre
        
        self.timetables = Timetable.getTimetablesByCourse(self.course!, ctx: globalCtx)
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
        return self.timetables.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timetableCell", forIndexPath: indexPath) as! TimetableTableViewCell
        
        cell.professorButton.addTarget(self, action: #selector(CourseDetailViewController.showProfessors), forControlEvents: .TouchUpInside)
        cell.downloadButton.addTarget(self, action: #selector(CourseDetailViewController.downloadEvidence), forControlEvents: .TouchUpInside)

        let timetable = self.timetables[indexPath.row]
        
        cell.timetableCode.text = timetable.codigo
        
        return cell
    }
    
    //MARK: - Functions
    
    func showProfessors(){
        self.performSegueWithIdentifier("professorDetailSegue", sender: self)
    }
    
    func downloadEvidence(){
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "professorDetailSegue" {
            let indexPath = self.timetableTableView.indexPathForView(self.timetableTableView)
            let tvc = segue.destinationViewController as! ProfessorsTVC
            tvc.timetable = self.timetables[indexPath!.row]
        }
        
        if segue.identifier == "courseReportSegue" {
            let wvc = segue.destinationViewController as! CourseResultsViewController
            wvc.faculty = self.faculty
            wvc.course = self.course
        }
    }

}
