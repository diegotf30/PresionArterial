//
//  TransisViewController.swift
//  heartPressureApp
//
//  Created by Jose Castillo Valdez on 5/1/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit

class TransisViewController: UIViewController {
    
    var tipoUsuario : String!
    var tasa : Double!
    var sist : String!
    var diast : String!
    var pulso : String!
    var msist : String!
    var mdist : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultados" {
            let resultsView = segue.destination as! InformacionDoctorViewController
            resultsView.sist = self.sist
            resultsView.diast = self.diast
            resultsView.tasa = self.tasa
            resultsView.pulso = self.pulso
            resultsView.mdist = self.mdist
            resultsView.msist = self.msist
        }
        else if segue.identifier == "search"{
            let searchView = segue.destination as! ListaPacientesViewController
            searchView.tipoUsuario = self.tipoUsuario
            searchView.pulso = self.pulso
            searchView.sist = self.sist
            searchView.diast = self.diast
            searchView.msist = self.msist
            searchView.mdist = self.mdist
        }
        
        
    }
    

}
