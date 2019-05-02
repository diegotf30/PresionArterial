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
    
    var bt = Bluetooth()
    var arrData : [[Float]] = []
    var lastDataPoint = [Float]()
    var startProcessing = false
    
    var mitad = 0 //indice de la mitad de los datos
    var amp = 0.0 //amplitud de presión
    var sist = 0.0 //sistolica
    var diast = 0.0 //diastolica
    var tasa = [Double]()
    var tasaDesinflado = 0.0
    
    let maxPressure = 260.0
    let pressureOK = 120.0
    let pressureWarning = 140.0
    
    // Original X: 10, Y: 10
    let test = GaugeView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        test.backgroundColor = .clear
        viewBarometro.addSubview(test)
        bt.startSearching(onFound: updateGraphs(_:))
    }

    func splitData( _ s : String) -> [Float] {
        let d = s.components(separatedBy: ";")
        return [Float(d[0])!, Float(d[1])!, Float(d[2])!]
    }
    
    func updateGraphs( _ s : String) {
        lastDataPoint = splitData(s) // [timestamp, pressure, pulse]

        if lastDataPoint[1] > 5 {
            startProcessing = true
        }
        

        if startProcessing && lastDataPoint[1] > 20 {
            arrData.append(lastDataPoint)
            animate(pressure: Double(lastDataPoint[1]))
        }
        else {
            startProcessing = false
            if(tipoUsuario == "Paciente"){
                self.performSegue(withIdentifier: "vistaPatient", sender: nil)
            }
            else if(tipoUsuario == "Doctor"){
                self.performSegue(withIdentifier: "vistaDoc", sender: nil)
            }
        }
    }
    
    // Updates baurometer and real-time pressure graph
    func animate(pressure: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Baurometer
            self.test.value = pressure
            // Graph
            let value = ChartDataEntry(x: Double(self.counter), y: pressure)
            self.lineChartData.append(value)
            
            self.counter += 1
            if(self.counter > 300){
                self.lineChartData.removeFirst()
            }
            self.lineChartUpdate(values: self.lineChartData)
        }
    }
    
    func lineChartUpdate(values: [ChartDataEntry]){
        // X : Time && Y : Pressure (mmHg)
        
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
