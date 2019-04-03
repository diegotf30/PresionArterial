//
//  ResultadoDoctorViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit

class ResultadoDoctorViewController: UIViewController {

    @IBOutlet weak var btnOmitir: UIButton!
    @IBOutlet weak var btnAgregar: UIButton!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var resultadosView: UIView!

    @IBOutlet weak var datosView: UIView!

    @IBOutlet weak var lbPresion: UILabel!
    @IBOutlet weak var lbTasa: UILabel!
    @IBOutlet weak var lblPulso: UILabel!
    
    var tasaDesinflado : Double!
    var sistolica : String!
    var diastolica : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbPresion.text = sistolica + " / " + diastolica
        lbTasa.text = String(format: "%0.5f", tasaDesinflado)
        lblPulso.text = String(Int.random(in: 60..<100))
        
        btnSiguiente.layer.cornerRadius = 5
        btnOmitir.layer.cornerRadius = 5
        btnAgregar.layer.cornerRadius = 5
        
        resultadosView.isHidden = true
    }
    
    @IBAction func btnAgregarPresion(_ sender: Any) {
        resultadosView.isHidden = false
    }
    
    @IBAction func btnIgnorarPresion(_ sender: Any) {
        resultadosView.isHidden = false
    }
    
    @IBAction func quitarTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! InformacionDoctorViewController
        nextView.sistolica = sistolica
        nextView.diastolica = diastolica
        nextView.pulso = String(lblPulso.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
