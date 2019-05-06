//
//  InformacionDoctorViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit
import Firebase

class InformacionDoctorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfSiglas: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfEdad: UITextField!
    @IBOutlet weak var tfPeso: UITextField!
    @IBOutlet weak var tfTalla: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    
    @IBOutlet weak var swHipertension: UISwitch!
    @IBOutlet weak var swDiabetes: UISwitch!
    @IBOutlet weak var swColesterol: UISwitch!
    @IBOutlet weak var swTabaquismo: UISwitch!
    
    @IBOutlet weak var viewPacienteNuevo: UIView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var tasa : Double!
    var sist : String!
    var diast : String!
    var pulso : String!
    var userName : String!
    var msist : String!
    var mdist : String!
    
    var db: Firestore!
    
    @IBAction func btnRegresar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        btnGuardar.layer.cornerRadius = 5
        viewPacienteNuevo.isHidden = false
        
        scrollView.contentSize = infoView.frame.size
        tfNombre.delegate = self
        tfEdad.delegate = self
        tfPeso.delegate = self
        tfTalla.delegate = self
    }
    
    @IBOutlet weak var segcontrol: UISegmentedControl!
    @IBAction func segControlPaciente(_ sender: Any) {
        if(segcontrol.selectedSegmentIndex == 0) {
            viewPacienteNuevo.isHidden = false
        } else {
            viewPacienteNuevo.isHidden = true
        }
    }
    
    @IBAction func quitarTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func btnGuardarInfo(_ sender: Any) {
            if (tfNombre.text == "" || Int(tfEdad.text!) == nil || Double(tfTalla.text!) == nil){
                let alert = UIAlertController(title: "Error", message: "Faltan datos para registrar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = formatter.string(from: Date())
                
                let post: [String: Any] = [
                    "Correo": tfCorreo.text!,
                    "Nombre":  tfNombre.text!,
                    "Edad": tfEdad.text!,
                    "Peso":   tfPeso.text!,
                    "Talla" : tfTalla.text!,
                    "Hipertensión": swHipertension.isOn,
                    "Diabetes": swDiabetes.isOn,
                    "Colesterol": swColesterol.isOn,
                    "Tabaquismo": swTabaquismo.isOn,
                    "Sistolica": [
                        date : diast
                        ],
                    "Diastolica": [
                        date : sist
                        ],
                    "Sistolica manual": [
                        date : mdist
                        ],
                    "Diastolica manual": [
                        date : msist
                        ]
                    ]
                //userName = Auth.auth().currentUser?.email
                db.collection("pacientes").document(tfCorreo.text!).setData(post){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
                let alert = UIAlertController(title: "Datos Correctos", message: "Se han guardado exitosamente", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "return", sender: nil)
                }))
                self.present(alert, animated: true)
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 6...7:
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        case 5:
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        case 4:
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
