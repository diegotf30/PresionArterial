//
//  AnimacionBarometroViewController.swift
//  heartPressureApp
//
//  Created by Alumno on 25/04/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit
import Charts

class AnimacionBarometroViewController: UIViewController {
    
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var viewChart: LineChartView!
    @IBOutlet weak var viewBarometro: UIView!
    
    let shapeLayer = CAShapeLayer()
    var tipoUsuario : String!
    
    var lineChartData = [ChartDataEntry]()
    var counter = 0
    
    var csvRows = [[String]]()
    var tiempo : Timer!
    var n = 0 //numero de datos en CSV
    var mitad = 0 //indice de la mitad de los datos
    var amp = 0.0 //amplitud de presión
    var sist = 0.0 //sistolica
    var diast = 0.0 //diastolica
    var tasa = [Double]()
    var tasaDesinflado = 0.0
    var row = 2
    
    let animTime = 20.0 //tiempo de animación
    let maxPressure = 260.0
    let pressureOK = 120.0
    let pressureWarning = 140.0
    
    // Original X: 10, Y: 10
    let test = GaugeView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        test.backgroundColor = .clear
        viewBarometro.addSubview(test)
        
        var data = readDataFromCSV(fileName: "TestsApp2", fileType: "csv")
        data = cleanRows(file: data!)
        csvRows = csv(data: data!) //matriz de una sola columna, primer valor esta en csvRows[2][0]
        n = csvRows.count - 1 - 1 //ajustar para indice y eliminar ultimo endline
        mitad = csvRows.count/2 + 2
        amp = Double(csvRows[2][3])!
        animateBarometer()
        obtenerResultados()
    }
    
    func animateBarometer(){
        tiempo = Timer.scheduledTimer(timeInterval: TimeInterval(animTime / Double(n)), target: self, selector: #selector(muestraNumero), userInfo: nil, repeats: true)
        // Incluir la Chart cunado termine el intervalo.
        // lineChartUpdate(values: self.lineChartData)
    }
    
    @IBAction func muestraNumero(){
        
        if(row + 2 == n){
            tiempo.invalidate()
            sleep(1)
            if(tipoUsuario == "Paciente"){
                self.performSegue(withIdentifier: "vistaPatient", sender: nil)
            }
            else if(tipoUsuario == "Doctor"){
                self.performSegue(withIdentifier: "vistaDoc", sender: nil)
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1) {
                self.test.value = Double(self.csvRows[self.row][0])!
                let value = ChartDataEntry(x: Double(self.counter), y: self.test.value)
                self.lineChartData.append(value)
                self.counter += 1
                // Que salgan todos los datos, comentar lo de abajo:
                if(self.counter > 100){
                    self.lineChartData.removeFirst()
                }
            }
            self.lineChartUpdate(values: self.lineChartData)
        }
        row += 1
    }
    
    func lineChartUpdate(values: [ChartDataEntry]){
        // X : Time && Y : Presion
        
        let line1 = LineChartDataSet(values: lineChartData, label: "Presion")
        
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.lineDashLengths = [5, 2.5]
        line1.highlightLineDashLengths = [5, 2.5]
        line1.setColor(.black)
        line1.setCircleColor(.black)
        line1.lineWidth = 1
        line1.circleRadius = 3
        line1.drawCircleHoleEnabled = false
        line1.valueFont = .systemFont(ofSize: 9)
        line1.formLineDashLengths = [5, 2.5]
        line1.formLineWidth = 30
        line1.formSize = 15
        
        let data = LineChartData(dataSet: line1)
        
        viewChart.data = data
        viewChart.zoomToCenter(scaleX: 0, scaleY: 0)
        viewChart.chartDescription?.text = "Test.-"
    }
    
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
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vistaDoc" {
            let vistaOp = segue.destination as! ManualViewController
            vistaOp.tasaDesinflado = tasaDesinflado
            vistaOp.sist = String(format: "%0.0f", sist)
            vistaOp.diast = String(format: "%0.0f", diast)
            vistaOp.tipoUsuario = self.tipoUsuario
        }
        else if segue.identifier == "vistaPatient" {
            let vistaM = segue.destination as! ResultadoDoctorViewController
            vistaM.tasa = tasaDesinflado
            vistaM.sist = String(format: "%0.0f", sist)
            vistaM.diast = String(format: "%0.0f", diast)
            vistaM.tipoUsuario = self.tipoUsuario
        }
    }
}
