//
//  ManualViewController.swift
//  heartPressureApp
//
//  Created by Alumno on 5/2/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {

    @IBOutlet weak var tfDiast: UITextField!
    @IBOutlet weak var tfSist: UITextField!
    
    var sist : String!
    var diast : String!
    var mSist : String!
    var mDiast : String!
    var tasaDesinflado : Double!
    var tipoUsuario : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func guardarManual(_ sender: UIButton) {
        if(tfSist.text == "" || tfDiast.text == ""){
            let alert = UIAlertController(title: "Faltan datos", message: "Favor de completar ambos campos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "return", sender: nil)
            }))
            self.present(alert, animated: true)
        }
        else{
            mDiast = tfDiast.text!
            mSist = tfSist.text!
            self.performSegue(withIdentifier: "details", sender: sender)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let nextView = segue.destination as! ResultadoDoctorViewController
            nextView.sist = sist
            nextView.diast = diast
            nextView.msist = mSist
            nextView.mdist = mDiast
            nextView.tipoUsuario = tipoUsuario
            nextView.tasa = tasaDesinflado
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
