//
//  MainMenuTVC.swift
//  UASApp
//
//  Created by Karl Montenegro on 05/05/16.
//  Copyright © 2016 puntobat. All rights reserved.
//

import UIKit

class MainMenuTVC: UITableViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    @IBOutlet weak var userSpecialty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
            case 1: //Inicio
                    print("Inicio")
                    break
            case 2: //Obj. Educacionales
                    print("Obj. Eduacionales")
                    break
            case 3: //Res. Estudiantiles
                    print("Res. Estudiantiles")
                    break
            case 4: //Rubricas
                    print("Rubricas")
                    break
            case 5: //Aspectos
                    print("Aspectos")
                    break
            case 6: //Criterios
                    print("Criterios")
                    break
            case 7: //Cursos
                    print("Cursos")
                    break
            case 8: //Mejora Continua
                    print("Mej. Continua")
                    break
            case 9: //Resultados de Evaluaciones
                    print("Res. Evaluaciones")
                    break
            case 11: //Cerrar Sesion
                    print("Cerrar Sesion")
                    break
            default: break
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
