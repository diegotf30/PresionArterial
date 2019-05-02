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
    var tempNombre = [String]()
    var i = 0
    var tipoUsuario : String!
    
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tfSearch: UITextField!
    
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
    
    @IBAction func btnRegresar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if isSearching{
           
        }
        else{
            
        }*/
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
