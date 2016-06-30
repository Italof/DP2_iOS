//
//  ImprovementCell.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class ImprovementCell: UITableViewCell {


    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblAnalysis: UITextView!
    @IBOutlet weak var lblDescription: UITextView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
