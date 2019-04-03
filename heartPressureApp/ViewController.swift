//
//  ViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/5/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


class ViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datosView: UIView!
    @IBOutlet weak var tfMail: UITextField!
    @IBOutlet weak var tfPsswd: UITextField!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var googleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.cancelsTouchesInView = false
        scrollView.contentSize = datosView.frame.size
        btnIngresar.layer.cornerRadius = 5

        
        tfMail.delegate = self
        tfPsswd.delegate = self

        let googleButton = GIDSignInButton()
        
        googleButton.frame = CGRect(x:0, y: 0, width: 100, height: btnIngresar.frame.height)
        googleButton.center = googleView.center
        datosView.addSubview(googleButton)
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }

    @IBAction func quitaTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        signIn()
    }
    
    private func signIn(){
        let email = tfMail.text!
        let password = tfPsswd.text!
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Failed to sign in to Firebase", err)
                return
            }
            self.performSegue(withIdentifier: "signin", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signin"{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.usuario = tfMail.text!
        }
        
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
    
    @IBAction func signOutGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

