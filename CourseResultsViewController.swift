//
//  CourseResultsViewController.swift
//  UASApp
//
//  Created by Karl Montenegro on 01/07/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CourseResultsViewController: UIViewController {

    var faculty : Faculty?
    var course : Course?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fileURL = DocumentDirURL.URLByAppendingPathComponent("course_report_" + self.faculty!.id.description + "_" + self.course!.id.description).URLByAppendingPathExtension("html")
        
        let myRequest = NSURLRequest(URL: fileURL);
        self.webView.loadRequest(myRequest)
        // Do any additional setup after loading the view.
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
