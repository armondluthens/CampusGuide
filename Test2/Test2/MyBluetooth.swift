//
//  MyBluetooth.swift
//  BluetoothTest
//
//  Created by Stephanie Smith on 12/1/16.
//  Copyright © 2016 FantasticFour. All rights reserved.
//

import Foundation
import CoreBluetooth

// make custom bluetooth protocol to handle connecting and
// communicating with the HM-10 bluetooth module

var myBluetooth: MyBluetooth!

protocol MyBluetoothManager {
    
    func receivedMessage(_ message: String)
    
    func receivedMessage(_ message: [UInt8])
    
    func receivedMessage(_ message: Data)
    
    func failedToConnectToPeripheral(_ peripheral: CBPeripheral, error: NSError?)
}

// making the protocol methods optional by adding default support
extension MyBluetoothManager {
    
    func receivedMessage(_ message: String){}
    func receivedMessage(_ message: [UInt8]){}
    func receivedMessage(_ message: Data){}
    func failedToConnectToPeripheral(_ peripheral: CBPeripheral, error: NSError?){}
    
}

class MyBluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    let SERVICE_UUID: CBUUID = CBUUID(string: "FFE0")
    let CHARACTERISTIC_UUID: CBUUID = CBUUID(string: "FFE1")
    private var writeType: CBCharacteristicWriteType = .withoutResponse
    private var scanStatus: Bool = false
    private var peripheralCount: Int = 0
    // optionals
    private var delegate: MyBluetoothManager!
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var writeCharacteristic: CBCharacteristic!
    
    // whether the phone and the bluetooth module is ready to send and receive data
    var isReady: Bool {
        get {
            return centralManager.state == .poweredOn &&
                peripheral != nil &&
                writeCharacteristic != nil
        }
    }
    init(delegate: MyBluetoothManager){
        super.init()
        self.delegate = delegate;
        centralManager = CBCentralManager(delegate: self, queue: nil)
        scanStatus = false;
        // print("init")
    }
    func scan(){
        // print("scan")
        // don't start scanning unless our bluetooth is on
        guard centralManager.state == .poweredOn else{ return }
        // start scanning for the correct module
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
        scanStatus = true
        
        // what if it discovered multiple peripherals?
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [SERVICE_UUID])
        peripheralCount = peripherals.count
        
        if(peripheralCount > 1){
            print("problem")
            // encountered a problem
        }
    }
    func stopScan(){
        centralManager.stopScan()
        scanStatus = false
    }
    // disconnect from the connected peripheral or stop connecting to it
    func disconnectFromPeripheral() {
        if let p = peripheral {
            centralManager.cancelPeripheralConnection(p)
        }
    }
    // send message to wearable
    func sendMessageToWearable(string: String) {
        guard isReady else { return }
        if let data = string.data(using: String.Encoding.utf8) {
            peripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
        }
    }
    func sendMessageToWearable(bytes: [UInt8]) {
        guard isReady else { return }
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        peripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    func sendMessageToWearable(data: Data) {
        guard isReady else { return }
        peripheral.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    
    // MARK: CBCentralManagerDelegate functions
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        print("update state 2")
        guard central.state  == .poweredOn else {
            // In a real app, you'd deal with all the states correctly
            return
        }
        if(scanStatus == false){
            peripheral = nil
            scan()
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover discoveredPeripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("did discover 2")
        
        // module is within a reasonable range and we have not already connected to it
        // connect to it
        if  RSSI.intValue < -15 && discoveredPeripheral != self.peripheral {
            print("bleh")
            self.peripheral = discoveredPeripheral
            //peripheralStatus.isPending = true
            centralManager.connect(self.peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil;
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // didn't connect so set to nil
        self.peripheral = nil
        // send it to the delegate for the user to catch the error
        delegate.failedToConnectToPeripheral(peripheral, error: error as NSError?)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        // set up delegate to read and right to peripheral
        peripheral.delegate = self
        self.peripheral = peripheral
        // subscribe to the perpheral's services
        peripheral.discoverServices([SERVICE_UUID])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("discovered services")
        // discover the 0xFFE1 characteristic for all services (though there should only be one)
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CHARACTERISTIC_UUID], for: service) }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // check whether the characteristic we're looking for (0xFFE1) is present - just to be sure
        for characteristic in service.characteristics! {
            if characteristic.uuid == CHARACTERISTIC_UUID {
                // subscribe to this value (so we'll get notified when there is serial data for us..)
                peripheral.setNotifyValue(true, for: characteristic)
                // keep a reference to this characteristic so we can write to it
                writeCharacteristic = characteristic
                print("finished")
            }
        }
    }
    // received data
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        // notify the delegate in different ways
        print("received")
        let data = characteristic.value
        guard data != nil else { return }
        
        // message in data form
        delegate.receivedMessage(data!)
        
        // message in string form
        if let str = String(data: data!, encoding: String.Encoding.utf8) {
            delegate.receivedMessage(str)
            print(str)
        }
        // now the bytes array
        var bytes = [UInt8](repeating: 0, count: data!.count / MemoryLayout<UInt8>.size)
        (data! as NSData).getBytes(&bytes, length: data!.count)
        delegate.receivedMessage(bytes)
    }
}
