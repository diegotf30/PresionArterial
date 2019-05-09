//
//  Bluetooth.swift
//  heartPressureApp
//
//  Created by Pamela Martínez on 5/1/19.
//  Copyright © 2019 Isabela Escalante. All rights reserved.
//

import UIKit
import BlueCapKit
import CoreBluetooth

class Bluetooth: NSObject {
    public enum AppError : Error {
        case dataCharactertisticNotFound
        case enabledCharactertisticNotFound
        case updateCharactertisticNotFound
        case serviceNotFound
        case invalidState
        case resetting
        case poweredOff
        case unknown
    }
    var dataCharacteristic : Characteristic?
    
    //Data processing
    var first = true
    var last : String!

    
    func startSearching(onFound: @escaping (_ d: [Float]) -> Void) {
        let serviceUUID = CBUUID(string:"ffe0")
        var peripheral: Peripheral?
        let dateCharacteristicUUID = CBUUID(string:"ffe1")
        
        //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
        let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
        
        //A future stram that notifies us when the state of the central manager changes
        let stateChangeFuture = manager.whenStateChanges()
        
        //handle state changes and return a scan future if the bluetooth is powered on.
        let scanFuture = stateChangeFuture.flatMap { state -> FutureStream<Peripheral> in
            switch state {
            case .poweredOn:
                DispatchQueue.main.async {
                    print("start scanning")
                }
                //scan for peripherlas that advertise the ec00 service
                return manager.startScanning(forServiceUUIDs: [serviceUUID])
            case .poweredOff:
                throw AppError.poweredOff
            case .unauthorized, .unsupported:
                throw AppError.invalidState
            case .resetting:
                throw AppError.resetting
            case .unknown:
                //generally this state is ignored
                throw AppError.unknown
            }
        }
        
        scanFuture.onFailure { error in
            guard let appError = error as? AppError else {
                return
            }
            switch appError {
            case .invalidState:
                break
            case .resetting:
                manager.reset()
            case .poweredOff:
                break
            case .unknown:
                break
            default:
                break;
            }
        }
        
        //We will connect to the first scanned peripheral
        let connectionFuture = scanFuture.flatMap { p -> FutureStream<Void> in
            //stop the scan as soon as we find the first peripheral
            manager.stopScanning()
            peripheral = p
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            DispatchQueue.main.async {
                print("Found peripheral \(peripheral.identifier.uuidString). Trying to connect")
            }
            //connect to the peripheral in order to trigger the connected mode
            return peripheral.connect(connectionTimeout: 10, capacity: 5)
        }
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap { _ -> Future<Void> in
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            return peripheral.discoverServices([serviceUUID])
            }.flatMap { _ -> Future<Void> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let service = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw AppError.serviceNotFound
                }
                peripheral = discoveredPeripheral
                DispatchQueue.main.async {
                    print("Discovered service \(service.uuid.uuidString). Trying to discover characteristics")
                }
                //we have discovered the service, the next step is to discover the "ec0e" characteristic
                return service.discoverCharacteristics([dateCharacteristicUUID])
        }
        
        /**
         1- checks if the characteristic is correctly discovered
         2- Register for notifications using the dataFuture variable
         */
        let dataFuture = discoveryFuture.flatMap { _ -> Future<Void> in
            guard let discoveredPeripheral = peripheral else {
                throw AppError.unknown
            }
            guard let dataCharacteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                throw AppError.dataCharactertisticNotFound
            }
            self.dataCharacteristic = dataCharacteristic
            DispatchQueue.main.async {
                print("Discovered characteristic \(dataCharacteristic.uuid.uuidString). COOL :)")
            }
            
            //read the data from bt device
            self.dataCharacteristic?.read(timeout: 5)
            
            //Ask the characteristic to start notifying for value change
            return dataCharacteristic.startNotifying()
            }.flatMap { _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let characteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                    throw AppError.dataCharactertisticNotFound
                }
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return characteristic.receiveNotificationUpdates(capacity: 10)
        }
        
        //The onSuccess method is called every time the characteristic value changes
        dataFuture.onSuccess { data in
            let s = String(data:data!, encoding: .utf8)
            DispatchQueue.main.async {
                self.cleanDataPoint(dataPoint: s!, closure: onFound)
            }
        }
        
        //handle any failure in the previous chain
        dataFuture.onFailure { error in
            switch error {
            case PeripheralError.disconnected:
                peripheral?.reconnect()
            case AppError.serviceNotFound:
                break
            case AppError.dataCharactertisticNotFound:
                break
            default:
                break
            }
        }
    }
    
    // Los datos de BT vienen partidos, una vez consolidado 1 dato llamamos la función pasada
    func cleanDataPoint(dataPoint: String, closure: @escaping (_ d: [Float]) -> Void) {
        var x = dataPoint.components(separatedBy: "\r\n")
        if first {
            // Since we're sending data even before connection, we ignore first (broken) datapoint
            if x.count > 1 {
                last = x[1]
                first = false
            }
        }
        else {
            if x.count == 2 {
                let data = last + x[0]
                let split = data.components(separatedBy: "\r\n")
                if split.count > 1 {
                    closure(splitData(split[0]))
                    closure(splitData(split[1]))
                }
                else {
                    closure(data)
                }
                last = x[1]
            }
            else if x.count == 3 {
                closure(splitData(last + x[0]))
                closure(splitData(x[1]))
                last = x[2]
            }
            else {
                last += x[0]
            }
        }
    }

    func splitData( _ s : String) -> [Float] {
        let d = s.components(separatedBy: ";")
        return [Float(d[0])!, Float(d[1])!, Float(d[2])!]
    }
}
