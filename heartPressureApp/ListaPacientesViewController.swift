//
//  ViewControllerMostrar.swift
//  loginUser
//
//  Created by Alumno on 4/5/19.
//  Copyright © 2019 Alumno. All rights reserved.
//

import UIKit

import Firebase

class ListaPacientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var filteredData = [String]()
    var isSearching = false
    
    var db: Firestore!
    var listaNombres = [String]()
    var id : String!
    var tempNombre = [String]()
    var i = 0
    var tipoUsuario : String!
    var pulso : String!
    var sist : String!
    var diast : String!
    var msist : String!
    var mdist : String!
    
    
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        getCollection()
        
        tbView.delegate = self
        tbView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        /*
        
        
        //tbView.isHidden = true
        for str in listaNombres{
            print(str)
            //tempNombre.append(str)
        }
        
        tfSearch.addTarget(self, action: #selector(searchRecords(_:)), for: .editingChanged)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        tfSearch.addTarget(self, action: #selector(ListaPacientesViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        */
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
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredData.count
        }
        return listaNombres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        if isSearching{
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else{
            cell.textLabel?.text = listaNombres[indexPath.row]
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            tbView.reloadData()
        }
        else{
            isSearching = true
            filteredData = listaNombres.filter{$0.contains(searchBar.text!)}
            tbView.reloadData()
        }
    }
    
    func saveResults(documentName : String!){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: Date())
        
        db.collection("pacientes").document(documentName).setData([ "Sistolica": [
            date : sist
            ],
            "Distolica": [
                date : diast
            ],
            "Sistolica manual":[
                date : msist
            ],
            "Distolica manual":[
                date : mdist
            ]
            ], merge: true)
        let alert = UIAlertController(title: "Éxito", message: "La medición fue guardada exitosamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearching{
            db.collection("pacientes").whereField("Nombre", isEqualTo: filteredData[indexPath.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.id = document.documentID
                            self.saveResults(documentName: self.id)
                        }
                    }
            }
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "regresarCalc", sender: cell)
        }
        else{
            db.collection("pacientes").whereField("Nombre", isEqualTo: listaNombres[indexPath.row])
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.id = document.documentID
                            self.saveResults(documentName: self.id)
                        }
                    }
            }
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "regresarCalc", sender: cell)
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
