//
//  CalcularViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CalcularViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var btnCalcular: UIButton!
    var usuario : String!
    var inicioSesion : Bool! = false
    var ref: DatabaseReference!
    var databaseHande : DatabaseHandle!
    var tipoUsuario: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCalcular.layer.cornerRadius = 0.34 * btnCalcular.bounds.size.width
        
        /*
        ref = Database.database().reference()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            usuario = appDelegate.usuario
        if appDelegate.google{
            userType = "Paciente"
        }else{
            databaseHande = ref?.child("Usuarios").observe(.childAdded, with: { (snapshot) in
                let data = snapshot.value as? NSDictionary
                let type = data?["Tipo"] as! String
                let user = data?["usuario"] as! String
                if(user == self.usuario){
                    self.userType = type
                    print(self.userType)
                }
            })
        }
        */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePop" {
            let vistaPopOver = segue.destination as! PopOverViewController
            vistaPopOver.popoverPresentationController!.delegate = self
        }
        else if segue.identifier == "barometro"{
            let extraView = segue.destination as! AnimacionBarometroViewController
            extraView.tipoUsuario = self.tipoUsuario
        }
        else{
            let extraView = segue.destination as! ViewController
            extraView.tipoUsuario = self.tipoUsuario
        }

    }
    
    func adaptivePresentationStyle (for controller:
        UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    @IBAction func cerrarSesion(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
