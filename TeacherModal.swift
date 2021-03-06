//
//  TeacherModal.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class TeacherModal: UIViewController {
    
    @IBOutlet weak var lblTeacherName: UILabel!
    @IBOutlet weak var lblTeacherDegree: UILabel!
    @IBOutlet weak var lblTeacherRef: UITextView!
    @IBOutlet weak var teacherImg: UIImageView!
    
    var professor: Professor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstName = self.professor!.nombres!
        let lastName = self.professor!.apellidos!
        
        self.lblTeacherName.text = firstName + " " + lastName
        self.lblTeacherDegree.text = self.professor?.cargo
        
        self.lblTeacherRef.text = self.professor?.descripcion
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func closeTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
