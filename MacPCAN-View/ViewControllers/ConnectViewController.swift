//
//  ConnectViewController.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Cocoa

class ConnectViewController: NSViewController {
    
    @IBOutlet weak var mCANInterfaceComboBox: NSComboBox!
    @IBOutlet weak var mCANBusBaudrateComboBox: NSComboBox!
    @IBOutlet weak var mConnectButton: NSButton!
    @IBOutlet weak var mCancelButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Based on CANChannels enum */
        mCANInterfaceComboBox.numberOfVisibleItems = 9
        mCANInterfaceComboBox.sizeToFit()
        let lInterfaces: [String] = ["CHANNEL_NONE",
                                     "CHANNEL_USBBUS1",
                                     "CHANNEL_USBBUS2",
                                     "CHANNEL_USBBUS3",
                                     "CHANNEL_USBBUS4",
                                     "CHANNEL_USBBUS5",
                                     "CHANNEL_USBBUS6",
                                     "CHANNEL_USBBUS7",
                                     "CHANNEL_USBBUS8"]
        mCANInterfaceComboBox.addItems(withObjectValues: lInterfaces)
        
        /* Base on Baudrates enum */
        mCANBusBaudrateComboBox.numberOfVisibleItems = 14
        mCANBusBaudrateComboBox.sizeToFit()
        let lBaudrates: [String] = ["CAN_BR_1M",
                                    "CAN_BR_800K",
                                    "CAN_BR_500K",
                                    "CAN_BR_250K",
                                    "CAN_BR_125K",
                                    "CAN_BR_100K",
                                    "CAN_BR_95K",
                                    "CAN_BR_83K",
                                    "CAN_BR_50K",
                                    "CAN_BR_47K",
                                    "CAN_BR_33K",
                                    "CAN_BR_20K",
                                    "CAN_BR_10K",
                                    "CAN_BR_5K"]
        mCANBusBaudrateComboBox.addItems(withObjectValues: lBaudrates)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        /* TODO : Reset settings */
        
        /* Dismissing the current ViewControllet (sheet) */
        print("[DEBUG] <ConnectViewController::cancelButtonClicked> Dismissing ConnectViewcontroller")
        dismiss(self)
    }
    
    @IBAction func connectButtonClicked(_ sender: Any) {
        /* If nothing is seleced, do nothing */
        if((nil == mCANInterfaceComboBox!.objectValueOfSelectedItem) && (nil == mCANBusBaudrateComboBox!.objectValueOfSelectedItem)) {
            /* Both are empty */
            let lAlert: NSAlert = NSAlert()
            lAlert.messageText = "Wrong arguments !"
            lAlert.informativeText = "Both the CAN Interface and the CAN baudrate have not been set !"
            lAlert.alertStyle = NSAlert.Style.critical
            lAlert.addButton(withTitle: "OK")
            lAlert.beginSheetModal(for: self.view.window!)
        } else if (nil == mCANInterfaceComboBox!.objectValueOfSelectedItem) {
            /* Itf box is empty */
            let lAlert: NSAlert = NSAlert()
            lAlert.messageText = "Wrong arguments !"
            lAlert.informativeText = "The CAN Interface is not set !"
            lAlert.alertStyle = NSAlert.Style.critical
            lAlert.addButton(withTitle: "OK")
            lAlert.beginSheetModal(for: self.view.window!)
        } else if (nil == mCANBusBaudrateComboBox!.objectValueOfSelectedItem) {
            /* Baudrate box is empty */
            let lAlert: NSAlert = NSAlert()
            lAlert.messageText = "Wrong arguments !"
            lAlert.informativeText = "The CAN baudrate is not set !"
            lAlert.alertStyle = NSAlert.Style.critical
            lAlert.addButton(withTitle: "OK")
            lAlert.beginSheetModal(for: self.view.window!)
        } else {
            /* Attempt connect, throw alert if failed */
            let lItf: String = (mCANInterfaceComboBox!.objectValueOfSelectedItem as? String)! /* Null error if nothing in box ! */
            let lBr: String = (mCANBusBaudrateComboBox!.objectValueOfSelectedItem as? String)! /* Null error if nothing in box ! */
            print("[DEBUG] <ConnectViewController::connectButtonClicked> Chose Itf " + lItf + " (" + String(format:"0x%02X", canChannelFromString(lItf).rawValue) + ")")
            print("[DEBUG] <ConnectViewController::connectButtonClicked> Chose Baudrate " + lBr + " (" + String(format:"0x%02X", canBaudrateFromString(lBr).rawValue) + ")")
            
            let lDriver = CANDriver.instance()
            var lErrorText: String = String()
            let lStatus = lDriver.initDriver(canChannelFromString(lItf), canBaudrateFromString(lBr), &lErrorText)
            if(0 < lStatus) {
                let llErrorText = "[ERROR] Connection failed : " + lErrorText + " (status = " + String(format:"0x%04X", lStatus) + ")"
                print(llErrorText)
                let lAlert: NSAlert = NSAlert()
                lAlert.messageText = "Connection failed !"
                lAlert.informativeText = llErrorText
                lAlert.alertStyle = NSAlert.Style.critical
                lAlert.addButton(withTitle: "OK")
                lAlert.beginSheetModal(for: self.view.window!) { (response) in
                    /* Dismissing the current ViewController (sheet) */
                    print("[DEBUG] <ConnectViewController::connectButtonClicked> Dismissing ConnectViewcontroller via alert")
                    self.dismiss(self)
                }
            } else {
                /* Launching the CANReader thread */
                CANReader.instance().run()
                
                /* Dismissing the current ViewController (sheet) */
                print("[DEBUG] <ConnectViewController::connectButtonClicked> Dismissing ConnectViewcontroller")
                dismiss(self)
            }
        }
    }
}
