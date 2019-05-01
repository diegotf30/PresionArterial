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
    let test = GaugeView(frame: CGRect(x: 10, y: 10, width: 256, height: 256))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test.backgroundColor = .clear
        test.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2 - 180)
        view.addSubview(test)
        
        var data = readDataFromCSV(fileName: "TestsApp2", fileType: "csv")
        data = cleanRows(file: data!)
        csvRows = csv(data: data!) //matriz de una sola columna, primer valor esta en csvRows[2][0]
        n = csvRows.count - 1 - 1 //ajustar para indice y eliminar ultimo endline
        mitad = csvRows.count/2 + 2
        amp = Double(csvRows[2][3])!
        animateBarometer()
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
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1) {
                self.test.value = Double(self.csvRows[self.row][0])!
                let value = ChartDataEntry(x: Double(self.counter), y: self.test.value)
                self.lineChartData.append(value)
                self.counter += 1
            }
            self.lineChartUpdate(values: self.lineChartData)
        }
        row += 1
    }
    
    func lineChartUpdate(values: [ChartDataEntry]){
        // X : Time && Y : Presion
        
        let line1 = LineChartDataSet(values: lineChartData, label: "Presion")
        
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
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vistaOp = segue.destination as! OpcionesViewController
        vistaOp.tasa = tasaDesinflado
        vistaOp.sist = String(format: "%0.0f", sist)
        vistaOp.diast = String(format: "%0.0f", diast)
        vistaOp.tipoUsuario = self.tipoUsuario
    }
}
