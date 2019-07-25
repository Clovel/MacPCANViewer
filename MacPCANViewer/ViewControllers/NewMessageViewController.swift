//
//  NewMessageViewController.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 05/07/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Cocoa

class NewMessageViewController: NSViewController {

    @IBOutlet weak var mAddButton: NSButton!
    @IBOutlet weak var mCancelButton: NSButton!
    
    @IBAction func addButtonClicked(_ sender: NSButton) {
        print("[DEBUG] <NewMessageViewController::addButtonClicked> Add button clicked !")
    }

    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        /* TODO : Reset settings */

        /* Dismissing the current ViewControllet (sheet) */
        print("[DEBUG] <NewMessageViewController::cancelButtonClicked> Cancel button clicked !")
        dismiss(self)
    }

}
