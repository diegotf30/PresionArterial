//
//  RegistroViewController.swift
//  heartPressureApp
//
//  Created by Jose Andres Salazar on 11/5/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class RegistroViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var tfMail: UITextField!
    @IBOutlet weak var tfPsswd: UITextField!
    @IBOutlet weak var btnRegistro: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datosView: UIView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var ref: DatabaseReference!
    var tipoUsuario : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btnRegistro.layer.cornerRadius = 5
        scrollView.contentSize = datosView.frame.size
        tapGesture.cancelsTouchesInView = false
        
        tfMail.delegate = self
        tfPsswd.delegate = self
    }
    
    @IBAction func cambioUsuario(_ sender: UISegmentedControl) {
        if self.userType.selectedSegmentIndex == 0 {
            //Doctor
            self.tipoUsuario = "Doctor"
        }else{
            //Paciente
            self.tipoUsuario = "Paciente"
        }
    }
    
    @IBAction func quitaTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    
    func createUser(){
        let email = tfMail.text!
        let password = tfPsswd.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                let alert = UIAlertController(title: "Error al Registrarse", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Failed to create a Firebase user", err)
                return
            }
            
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.usuario = email
            //appDelegate.registro = true
            //appDelegate.google = false
            //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //let nextView = mainStoryboard.instantiateViewController(withIdentifier: "Calcular")
            //self.present(nextView, animated: true, completion: nil)
            print("Created Firebase user")
            //guard let user = authResult?.user else { return }
        }
    }
    
    @IBAction func registro(_ sender: UIButton) {
        createUser()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calcular" {
            let nextView = segue.destination as! CalcularViewController
            nextView.tipoUsuario = self.tipoUsuario
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
