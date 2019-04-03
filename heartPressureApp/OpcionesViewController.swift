//
//  OpcionesViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/30/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit

class OpcionesViewController: UIViewController {

    var tasa : Double!
    var sist : String!
    var diast : String!
    var tipoUsuario : String!
    
    @IBAction func btnCalcular(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tipoUsuario)
        // Do any additional setup after loading the view.
    }

    @IBAction func btnResultados(_ sender: Any) {
        if self.tipoUsuario == "Doctor"{
            self.performSegue(withIdentifier: "doctor", sender: nil)
        }else{
            self.performSegue(withIdentifier: "paciente", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doctor" {
            let vistaRes = segue.destination as! ResultadoDoctorViewController
            vistaRes.tasaDesinflado = tasa
            vistaRes.sistolica = sist
            vistaRes.diastolica = diast
        }else{
            let vistaResPaciente = segue.destination as! ResultadoPacienteViewController
            vistaResPaciente.diastolica = diast
            vistaResPaciente.sistolica = sist
            vistaResPaciente.tasaDesinflado = tasa
        }
        
    }

}
