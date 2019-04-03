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
    @IBOutlet weak var tfHipertension: UITextField!
    @IBOutlet weak var tfDiabetes: UITextField!
    @IBOutlet weak var tfColesterol: UITextField!
    @IBOutlet weak var tfTabaquismo: UITextField!
    
    @IBOutlet weak var viewPacienteNuevo: UIView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var sistolica : String!
    var diastolica : String!
    var pulso : String!
    
    var ref: DatabaseReference!
    
    @IBAction func btnRegresar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btnGuardar.layer.cornerRadius = 5
        viewPacienteNuevo.isHidden = false
        
        scrollView.contentSize = infoView.frame.size
        
        tfSiglas.delegate = self
        tfNombre.delegate = self
        tfEdad.delegate = self
        tfPeso.delegate = self
        tfTalla.delegate = self
        tfHipertension.delegate = self
        tfDiabetes.delegate = self
        tfColesterol.delegate = self
        tfTabaquismo.delegate = self
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
        if (segcontrol.selectedSegmentIndex == 0){
            if (tfNombre.text == "" || Int(tfEdad.text!) == nil || Double(tfTalla.text!) == nil){
                let alert = UIAlertController(title: "Error", message: "Faltan datos para registrar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = formatter.string(from: Date())
                let post = [
                    "Fecha": date,
                    "Nombre":  tfNombre.text!,
                    "Edad": tfEdad.text!,
                    "Peso":   tfPeso.text!,
                    "Talla" : tfTalla.text!,
                    "Hipertensión": tfHipertension.text!,
                    "Diabetes": tfDiabetes.text!,
                    "Colesterol": tfColesterol.text!,
                    "Tabaquismo": tfTabaquismo.text!,
                    "Presion": sistolica + "/" + diastolica,
                    "Pulso": pulso
                    ] as [String : Any]
                ref?.child("Pacientes Nuevos").childByAutoId().setValue(post)
                let alert = UIAlertController(title: "Datos Correctos", message: "Se han guardado exitosamente", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "return", sender: nil)
                }))
                self.present(alert, animated: true)
            }
        }else if(segcontrol.selectedSegmentIndex == 1){
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
