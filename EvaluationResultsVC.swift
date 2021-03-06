//
//  EvaluationResultsVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 17/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class EvaluationResultsVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var faculty : Faculty?
    
    @IBOutlet weak var reportLoaderModalView: UIView!
    @IBOutlet weak var reportLoaderIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.reportLoaderModalView.hidden = true
        self.reportLoaderIndicator.hidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = DocumentDirURL.URLByAppendingPathComponent("report_faculty_" + self.faculty!.id.description).URLByAppendingPathExtension("html")

        let myRequest = NSURLRequest(URL: fileURL);
        self.webView.loadRequest(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
