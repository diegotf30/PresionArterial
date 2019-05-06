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
    @IBOutlet weak var btnRegresar: UIButton! // Btn Regresar
    @IBOutlet weak var resultadosView: UIView!

    @IBOutlet weak var datosView: UIView!

    @IBOutlet weak var lbPresion: UILabel!
    @IBOutlet weak var lbTasa: UILabel!
    @IBOutlet weak var lblPulso: UILabel!
    
    var tipoUsuario : String!
    var tasa : Double!
    var sist : String!
    var diast : String!
    var msist : String!
    var mdist : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tipoUsuario)
        
        if(tipoUsuario == "Paciente"){
            btnRegresar.isHidden = false
        } else if (tipoUsuario == "Doctor"){
            btnRegresar.isHidden = false
            btnSiguiente.isHidden = false
        }
        
        lbPresion.text = sist + " / " + diast
        lbTasa.text = String(format: "%0.0f", tasa)
        lblPulso.text = String(Int.random(in: 60..<100))
        
        btnSiguiente.layer.cornerRadius = 5
        btnOmitir.layer.cornerRadius = 5
        btnAgregar.layer.cornerRadius = 5
        
        // resultadosView.isHidden = true
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
        if segue.identifier == "siguiente" {
            let nextView = segue.destination as! TransisViewController
            nextView.sist = sist
            nextView.diast = diast
            nextView.pulso = String(lblPulso.text!)
            nextView.msist = self.msist
            nextView.mdist = self.mdist
            
        } else {
            let returnView = segue.destination as! CalcularViewController
            returnView.tipoUsuario = self.tipoUsuario
        }
        
        
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
