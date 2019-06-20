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

