//
//  ViewController.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Cocoa

class MessagesViewController: NSViewController {
    
    var mCANDriverManager: CANDriverManager = CANDriverManager.instance()
    
    @IBOutlet var mRxMsgTableView: NSTableView!
    @IBOutlet var mTxMsgTableView: NSTableView!
    //@IBOutlet var mToolBar: NSToolbar!
    
    @IBAction func connectClicked(_ sender: NSToolbarItem) {
        print("[DEBUG] \"Connect\" was clicked !")
    }
    
    @IBAction func disconnectClicked(_ sender: NSToolbarItem) {
        print("[DEBUG] \"Disconnect\" was clicked !")
        let lDriver: CANDriver = CANDriver.instance()
        if(lDriver.isInitialized()) {
            var lErrorText: String = ""
            let lStatus = lDriver.closeDriver(&lErrorText)
            if(0 < lStatus) {
                let llErrorText = "[ERROR] Connection failed : " + lErrorText + " (status = " + String(format:"0x%04X", lStatus) + ")"
                print(llErrorText)
                let lAlert: NSAlert = NSAlert()
                lAlert.messageText = "Failed to disconnect CAN channel !"
                lAlert.informativeText = llErrorText
                lAlert.alertStyle = NSAlert.Style.critical
                lAlert.addButton(withTitle: "OK")
                lAlert.beginSheetModal(for: self.view.window!) { (response) in
                    /* Nothing */
                }
            } else {
                print("[INFO ] Successfully disconnected CAN channel " + String(lDriver.channel()))
            }
        } else {
            let lErrorText: String = "[ERROR] Disconnection failed : the CAN driver is not connected to any channel !"
            let lAlert: NSAlert = NSAlert()
            lAlert.messageText = "Failed to disconnect CAN channel !"
            lAlert.informativeText = lErrorText
            lAlert.alertStyle = NSAlert.Style.critical
            lAlert.addButton(withTitle: "OK")
            lAlert.beginSheetModal(for: self.view.window!) { (response) in
                /* Nothing */
            }
        }
    }
    
    @IBAction func newMessageClicked(_ sender: NSToolbarItem) {
        print("[DEBUG] \"New Message\" was clicked !")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // self.view.setFrameSize(NSSize(width: 640, height: 360))
        
        print("Hello world !")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

