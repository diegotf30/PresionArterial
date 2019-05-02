//
//  BarometroViewController.swift
//  heartPressureApp
//
//  Created by Isabela Escalante on 10/12/18.
//  Copyright © 2018 Isabela Escalante. All rights reserved.
//

import UIKit

class BarometroViewController: UIViewController {
    @IBOutlet weak var lblPercent: UILabel!
    let shapeLayer = CAShapeLayer()
    var tipoUsuario : String!
    
    var csvRows = [[String]]()
    var tiempo : Timer!
    var n = 0 //numero de datos en CSV
    var mitad = 0 //indice de la mitad de los datos
    var amp = 0.0 //amplitud de presión
    var sist = 0.0 //sistolica
    var diast = 0.0 //diastolica
    var tasa = [Double]()
    var tasaDesinflado = 0.0
    
    let animTime = 20.0 //tiempo de animación
    let maxPressure = 260.0
    let pressureOK = 120.0
    let pressureWarning = 140.0
    
    //Colores barometro
    let colorGreen = UIColor(red: 0.207, green: 0.678, blue: 0.176, alpha: 1.0)
    let colorYellow = UIColor(red: 0.949, green: 0.878, blue: 0.2094, alpha: 1.0)
    let colorRed = UIColor(red: 0.858, green: 0.007, blue: 0.007, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        lblPercent.font = UIFont.monospacedDigitSystemFont(ofSize: lblPercent.font!.pointSize, weight: UIFont.Weight.regular)
        
        var data = readDataFromCSV(fileName: "TestsApp2", fileType: "csv")
        data = cleanRows(file: data!)
        csvRows = csv(data: data!) //matriz de una sola columna, primer valor esta en csvRows[2][0]
        n = csvRows.count - 1 - 1 //ajustar para indice y eliminar ultimo endline
        mitad = csvRows.count/2 + 2
        amp = Double(csvRows[2][3])!

        makecircle()
        animateBarometer()
        obtenerResultados()
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblPercent.font = UIFont.monospacedDigitSystemFont(ofSize: lblPercent.font!.pointSize, weight: UIFont.Weight.regular)
        
        var data = readDataFromCSV(fileName: "TestsApp2", fileType: "csv")
        data = cleanRows(file: data!)
        csvRows = csv(data: data!) //matriz de una sola columna, primer valor esta en csvRows[2][0]
        n = csvRows.count - 1 - 1 //ajustar para indice y eliminar ultimo endline
        mitad = csvRows.count/2 + 2
        amp = Double(csvRows[2][3])!
        
        makecircle()
        animateBarometer()
        obtenerResultados()
    }
    
    //Funciones animación
    
    func makecircle(){
        let center = view.center
        //create track layer
        let trackLayer = CAShapeLayer() 
        let circularPath = UIBezierPath(arcCenter: center, radius: 140, startAngle: CGFloat.pi - CGFloat.pi / 4, endAngle:0 + CGFloat.pi / 4, clockwise: true)
        trackLayer.path = circularPath.cgPath
        let color = UIColor(red:0.25, green:0.74, blue:0.9, alpha:0.3)
        trackLayer.strokeColor = color.cgColor
        trackLayer.lineWidth = 30
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        //create circle
        //        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: CGFloat.pi - CGFloat.pi / 4, endAngle:0 + CGFloat.pi / 4, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        let color2 = UIColor(red:0.25, green:0.74, blue:0.85, alpha:1.0)
        shapeLayer.strokeColor = color2.cgColor
        shapeLayer.lineWidth = 30
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    func animateBarometer(){
        tiempo = Timer.scheduledTimer(timeInterval: TimeInterval(animTime / Double(n)), target: self, selector: #selector(muestraNumero), userInfo: nil, repeats: true)
    }
    
    @IBAction func muestraNumero(){
        
        if(n == 2){
            tiempo.invalidate()
            sleep(1)
            self.performSegue(withIdentifier: "opcion", sender: nil)
        }
        
        handleTap(endvalue: Double(csvRows[n][0])!/maxPressure)
        lblPercent.text = String(format: "%0.0f", Double(csvRows[n][0])!)
        
        if(n <= mitad){
            changeStrokeColor(value: Double(csvRows[n][0])!)
        }
        
        n = n - 1;
    }
    
    @IBAction private func handleTap(endvalue : Double){
        shapeLayer.strokeEnd = CGFloat(endvalue)
    }
    
    func changeStrokeColor(value : Double) {
        if(value <= pressureOK){
            shapeLayer.strokeColor = colorGreen.cgColor
        }else if(value > pressureOK && value <= pressureWarning){
            shapeLayer.strokeColor = colorYellow.cgColor
        }else{
           shapeLayer.strokeColor = colorRed.cgColor
        }
    }
    
    //FUNCIÓN DE CALCULOS
    func obtenerResultados(){
        var temp = 0.0
        var tasaTemp = 0.0
        
        //tasa de desinflado
        for i in (mitad + 1)...n
        {
            tasaTemp = Double(csvRows[i][0])! - Double(csvRows[i-1][0])!
            tasa.append(tasaTemp)
        }
        for i in 0...(tasa.count - 1){
            tasaDesinflado = tasaDesinflado + tasa[i]
        }
        tasaDesinflado = (tasaDesinflado/Double((tasa.count))) * 1000
        
        //sistolica
        for i in 3...mitad
        {
            if(csvRows[i][1] != "" && csvRows[i][2] != ""){
                temp = Double(csvRows[i][1])! - Double(csvRows[i][2])!
                if(temp >= 0.5*amp){
                    sist = Double(csvRows[i][0])!
                }
            }
        }
        
        //diastolica
        for i in 3...mitad
        {
            if(csvRows[i][1] != "" && csvRows[i][2] != ""){
                temp = Double(csvRows[i][1])! - Double(csvRows[i][2])!
                if(temp >= 0.8*amp){
                    diast = Double(csvRows[i][0])!
                    return
                }
            }
        }
    }
    
    //FUNCIONES PARA LEER DEL CSV
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }

    
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*let vistaOp = segue.destination as! OpcionesViewController
        vistaOp.tasa = tasaDesinflado
        vistaOp.sist = String(format: "%0.0f", sist)
        vistaOp.diast = String(format: "%0.0f", diast)
        vistaOp.tipoUsuario = self.tipoUsuario*/
    }
    

}
