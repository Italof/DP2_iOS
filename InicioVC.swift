//
//  InicioVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class InicioVC: UIViewController {

    @IBOutlet weak var facultyName: UILabel!
    @IBOutlet weak var facultyCode: UILabel!
    @IBOutlet weak var facultyDescription: UITextView!
    @IBOutlet weak var facultyCoordinator: UILabel!
    
    @IBOutlet weak var criteriaLevel: UILabel!
    @IBOutlet weak var acceptLevel: UILabel!
    @IBOutlet weak var acceptPercentage: UILabel!
    
    var faculty : Faculty?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.faculty!.period)
        
        self.facultyName.text = self.faculty?.nombre
        self.facultyCode.text = self.faculty?.codigo
        self.facultyDescription.text = self.faculty?.descripcion
        
        let firstName = self.faculty?.coordinator?.nombres
        let lastName = self.faculty?.coordinator?.apellidos
        
        if firstName != nil && lastName != nil {
            self.facultyCoordinator.text = firstName! + " " + lastName!
        } else {
            self.facultyCoordinator.text = "(Sin Coordinador)"
        }
        
        let critLevel = self.faculty?.period?.configuration?.criteriaLevel
        let accpLevel = self.faculty?.period?.configuration?.expectedLevel
        let percentLevel = self.faculty?.period?.configuration?.acceptTreshold
        
        if (critLevel != nil) {
            self.criteriaLevel.text = critLevel?.description
        } else {
            self.criteriaLevel.text = "-"
        }
        
        if (accpLevel != nil) {
            self.acceptLevel.text = accpLevel?.description
        } else {
            self.acceptLevel.text = "-"
        }
        
        if (percentLevel != nil) {
            self.acceptPercentage.text = percentLevel!.description + "%"
        } else {
            self.acceptPercentage.text = "0%"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
