//
//  BluetoothDefinitions.swift
//  SpeechToText
//
//  Created by Stephanie Smith on 11/1/16.
//  Copyright © 2016 Variya Soft Solutions. All rights reserved.
//

import CoreBluetooth


let TRANSFER_SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD666661"
let TRANSFER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6F66666D4"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)
