//
//  CursoCell.swift
//  UASApp
//
//  Created by Karl Montenegro on 06/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class CursoCell: UITableViewCell {

    @IBOutlet weak var lblCodigoCurso: UILabel!
    @IBOutlet weak var lblNivelCurso: UILabel!
    @IBOutlet weak var lblEspecialidadCurso: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
