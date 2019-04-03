//
//  ResultadoPacienteViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit

class ResultadoPacienteViewController: UIViewController {
    
    var tasaDesinflado : Double!
    var sistolica : String!
    var diastolica : String!

    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var lbConfiabilidad: UILabel!
    @IBOutlet weak var lbTasa: UILabel!
    @IBOutlet weak var lbPulso: UILabel!
    @IBOutlet weak var lbPresion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbPresion.text = sistolica + " / " + diastolica
        lbTasa.text = String(format: "%0.5f", tasaDesinflado)
        lbPulso.text = String(Int.random(in: 60..<100))

        btnSiguiente.layer.cornerRadius = 5
    }
    
    @IBAction func quitarTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! InformacionPacienteViewController
        nextView.sistolica = sistolica
        nextView.diastolica = diastolica
        nextView.pulso = String(lbPulso.text!)
    }

}
