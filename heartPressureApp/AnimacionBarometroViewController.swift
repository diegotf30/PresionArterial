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
    var sim = CSVSimulator()
    var arrData : [[Float]] = []
    var lastDataPoint = [Float]()
    var startProcessing = false
    
    var amp = 0.0 // amplitud de presión
    var sist = 0.0 // sistolica
    var diast = 0.0 // diastolica
    var tasa = [Double]()
    var tasaDesinflado = 0.0
    var maxIndex = -1
    
    let maxPressure = 260.0
    let pressureOK = 120.0
    let pressureWarning = 140.0
    
    // Original X: 10, Y: 10
    let test = GaugeView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        test.backgroundColor = .clear
        viewBarometro.addSubview(test)
        tipoUsuario = "Doctor"

        // Uncomment to get data from BT Device
        //bt.startSearching(onFound: updateGraphs(_:))
        sim.startSimulation(onUpdate: updateGraphs(_:))
    }
    
    func updateGraphs( _ d : [Float]) {
        lastDataPoint = d // [timestamp, pressure, pulse]

        if lastDataPoint[1] > 50 {
            startProcessing = true
        }

        if startProcessing && lastDataPoint[1] > 60 {
            arrData.append(lastDataPoint)
            animate(pressure: Double(lastDataPoint[1]))
        }
        else {
            startProcessing = false
            obtenerResultados()
            if(tipoUsuario == "Paciente") {
                self.performSegue(withIdentifier: "vistaPatient", sender: nil)
            }
            else if(tipoUsuario == "Doctor") {
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
            
            self.counter += 1
            if(self.counter > 50) { // So we dont saturate the graph
                self.lineChartData.append(value)
                self.counter = 0
            }
            self.lineChartUpdate(values: self.lineChartData)
        }
    }
    
    // Graphs pressure
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

    func obtenerResultados() {
        var n = arrData.count
        var mitad = n / 2
        var temp = 0.0
        var tasaTemp = 0.0
        var amp = getAmplitude()

        //tasa de desinflado
        for i in (mitad + 1)...n
        {
            tasaTemp = arrData[i][1])! - arrData[i - 1][1]
            tasa.append(tasaTemp)
        }
        for i in 0...(tasa.count - 1) {
            tasaDesinflado = tasaDesinflado + tasa[i]
        }
        tasaDesinflado = (tasaDesinflado / Double(tasa.count)) * 1000

        //sistolica
        for i in 0...maxIndex
        {
            if(arrData[i][1] >= 0.5 * amp) {
                sist = arrData[i][1]
                break
            }
        }

        //diastolica
        for i in maxIndex...n
        {
            if(arrData[i][1] <= 0.8 * amp) {
                diast = arrData[i][1]
                break
            }
        }
    }

    func getAmplitude() -> Float {
        max = -1.0
        for i in 0...arrData.count {
            dataPoint = arrData[i]
            if dataPoint[1] > max {
                max = dataPoint[1]
                maxIndex = i
            }
        }
        return max
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
