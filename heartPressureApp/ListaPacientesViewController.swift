//
//  ViewControllerMostrar.swift
//  loginUser
//
//  Created by Alumno on 4/5/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

import Firebase

class ListaPacientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!
    var listaNombres = [String]()
    var tempNombre = [String]()
    var i = 0
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        getCollection()
        
        
        
        tbView.isHidden = true
        for str in listaNombres{
            print(str)
            //tempNombre.append(str)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tfSearch.addTarget(self, action: #selector(searchRecords(_:)), for: .editingChanged)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        tfSearch.addTarget(self, action: #selector(ListaPacientesViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func getCollection() {
        // [START get_collection]
        db.collection("pacientes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.listaNombres.append("\(document.get("Nombre") ?? "no value")")
                    //print("\(document.get("Nombre") ?? "no value")")
                    //print("\(document.documentID) => \(document.get("nombre") ?? "no value")")
                    //print("\(document.get("Medicion") ?? "no value")")
                    
                }
            }
        }
        
        // [END get_collection]
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField.text != ""{
            tbView.isHidden = false
        }
        else{
            tbView.isHidden = true
        }
    }
    
    //MARK: searchRecords
    @objc func searchRecords(_ textField: UITextField){
        //listaNombres.removeAll()
        if textField.text?.count != 0 {
            for str in tempNombre{
                if let nombreToSearch = textField.text{
                    let range = str.lowercased().range(of: nombreToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil{
                        listaNombres.append(str)
                    }
                }
            }
        }
        else{
            for str in tempNombre{
                listaNombres.append(str)
            }
        }
        
        tbView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaNombres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        cell.textLabel?.text = listaNombres[indexPath.row]
        
        return cell
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
