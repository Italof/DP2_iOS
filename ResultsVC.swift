//
//  ResultsVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 17/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let localfilePath = NSBundle.mainBundle().URLForResource("reports3", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        self.webView.loadRequest(myRequest);
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
