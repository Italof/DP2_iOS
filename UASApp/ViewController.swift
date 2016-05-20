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
                    self.defaults.setObject(JSON.valueForKey("token"), forKey: "token")
                    self.performSegueWithIdentifier("facultyListSegue", sender: self)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "facultyListSegue" {
            
        }
    }

}

