//
//  ViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 02/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let endpoint: Connection = Connection()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    
                    self.defaults.setObject(json["token"].stringValue, forKey: "token")
                    do {
                    try self.defaults.setObject(json["user"].rawData(), forKey: "user")
                    } catch {
                        print(error)
                    }
                    
                    Alamofire.request(.GET, self.endpoint.url + "faculties?since=1463183832", headers: ["Authorization": "Bearer " + (self.defaults.objectForKey("token") as! String)])
                        .responseJSON { response in
                            switch response.result {
                            case .Success:
                                let json = JSON(data: response.data!)
                                TR_Faculty().store(json)
                                self.performSegueWithIdentifier("facultyListSegue", sender: self)
                            case .Failure(let error):
                                print(error)
                            }
                            
                    }
                case .Failure(let error):
                    self.alertMessage("Usuario/Contrasena incorrectos.", winTitle: "Error")
                }
            }
    }

    @IBAction func offlineTapped(sender: AnyObject) {
        self.defaults.setBool(true, forKey: "offline_session")
        self.performSegueWithIdentifier("facultyListSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "facultyListSegue" {

        }
    }
    
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

