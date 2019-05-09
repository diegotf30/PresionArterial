//
//  CSVSimulator.swift
//  heartPressureApp
//
//  Created by Pamela Martínez on 5/8/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit

class CSVSimulator: NSObject {
    var csvRows = [[String]]()
    var tiempo : Timer!
    var n = 0 // numero de datos en CSV
    var row = 2
    var update : @escaping (_ d: [Float]) -> Void

    init() {
        var data = readDataFromCSV(fileName: "TestsApp2", fileType: "csv")
        data = cleanRows(file: data!)
        csvRows = csv(data: data!) // matriz de una sola columna, primer valor esta en csvRows[2][0]

        n = csvRows.count - 1 - 1 // ajustar para indice y eliminar ultimo endline
        amp = Double(csvRows[2][3])!
    }

    @IBAction func muestraNumero() {
        if row + 2 == n {
            tiempo.invalidate()
            sleep(1)
        }
        // CSV is not formatted like BT device, so we translate to BT format
        lastDataPoint = [row, csvRows[row][0], -1] // [Timestamp, Pressure, Pulse (deprecated)]
        update(lastDataPoint)

        row += 1
    }

    func startSimulation(onUpdate: @escaping (_ d: [Float]) -> Void) {
        tiempo = Timer.scheduledTimer(timeInterval: TimeInterval(animTime / Double(n)), target: self, selector: #selector(muestraNumero), userInfo: nil, repeats: true)
        update = onUpdate
    }

    func readDataFromCSV(fileName:String, fileType: String) -> String!{
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

    func cleanRows(file:String) -> String{
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
}
