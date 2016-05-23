//
//  ViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 02/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint: Connection = Connection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.defaults.setBool(false, forKey: "offline_session")
        self.defaults.setObject("", forKey: "token")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTapped(sender: AnyObject) {
        
        let user:String = (self.txtUsername?.text)!
        let pass:String = (self.txtPassword?.text)!
        
        Alamofire.request(.POST, self.endpoint.url + "authenticate?user=\(user)&password=\(pass)")
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                
                    if JSON.valueForKey("token") != nil {
                        self.defaults.setObject(JSON.valueForKey("token"), forKey: "token")
                        self.defaults.setBool(false, forKey: "offline_session")
                        self.performSegueWithIdentifier("facultyListSegue", sender: self)
                    } else {
                        self.alertMessage("Usuario/Contrasena incorrectos.", winTitle: "Error")
                    }
                default:
                    print(response)
                }
        }
    }

    @IBAction func offlineTapped(sender: AnyObject) {
        self.defaults.setBool(true, forKey: "offline_session")
        self.performSegueWithIdentifier("facultyListSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "facultyListSegue" {
            if !self.defaults.boolForKey("offline_session") {
                self.loadFaculties()
            }
        }
    }
    
    func loadFaculties(){
        let token = self.defaults.objectForKey("token")!
        Alamofire.request(.GET, self.endpoint.url + "faculties?since=1463183832&token=\(token)")
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    FacultyTransactions().loadFaculties(JSON as? [AnyObject])
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

