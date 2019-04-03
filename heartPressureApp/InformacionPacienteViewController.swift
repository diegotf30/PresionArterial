//
//  InformacionPacienteViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class InformacionPacienteViewController: UIViewController {
    
    var sistolica : String!
    var diastolica : String!
    var pulso : String!
    @IBOutlet weak var tfSiglas: UITextField!
    var ref: DatabaseReference!
    
    @IBOutlet weak var btnGuardar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btnGuardar.layer.cornerRadius = 5

    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func guardarInfo(_ sender: Any) {
        if(tfSiglas.text == ""){
            let alert = UIAlertController(title: "Error", message: "Faltan datos para registrar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.string(from: Date())
            let post = [
                "Fecha": date,
                "Iniciales":  tfSiglas.text!,
                "Presion": sistolica + "/" + diastolica,
                "Pulso": pulso
                ] as [String : Any]
            ref?.child("Pacientes Existentes").childByAutoId().setValue(post)
            let alert = UIAlertController(title: "Datos Correctos", message: "Se han guardado exitosamente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "return", sender: nil)
            }))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func quitarTeclado(_ sender: Any) {
        view.endEditing(true)
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
