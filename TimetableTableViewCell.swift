//
//  TimetableTableViewCell.swift
//  UASApp
//
//  Created by Karl Montenegro on 30/06/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class TimetableTableViewCell: UITableViewCell {

    @IBOutlet weak var timetableCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func downloadTapped(sender: AnyObject) {
        
    }
    @IBAction func seeTeachersTapped(sender: AnyObject) {
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
