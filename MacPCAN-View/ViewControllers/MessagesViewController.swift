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
    var mCANReader: CANReader = CANReader.instance()
    var mSeekMessagesRunning: Bool = false
    var mRxMessages: [CANMessage] = [CANMessage]()
    var mTxMessages: [CANMessage] = [CANMessage]()
    
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

        /* Do any additional setup after loading the view. */
        mRxMsgTableView.delegate = self
        mRxMsgTableView.dataSource = self

        mTxMsgTableView.delegate = self
        mTxMsgTableView.dataSource = self
        
        print("Hello world !")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func reloadRxMessageList() {
        mRxMsgTableView.reloadData()
    }

    func reloadTxMessageList() {
        mTxMsgTableView.reloadData()
    }
    
    public func seekMessages() {
        if(mSeekMessagesRunning) {
            print("[ERROR] The CANReader is already running!")
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }

            while(true) {
                self.mSeekMessagesRunning = true
                while(self.mCANReader.running()) {
                    /* Check if any message are available in the Rx queue */
                    if(self.mCANReader.messageAvailable()) {
                        /* Get the message */
                        let lMsg: CANMessage = self.mCANReader.getMessage()!

                        /* Insert it in the table view */
                        let lSuccess: Bool = self.updateRxMessagesView(lMsg)
                        if(!lSuccess) {
                            print("[ERROR] <MessagesViewController::seekMessages> updateRxMessagesView failed !")
                        }
                    }
                }
            }
        }
    }

    fileprivate func updateRxMessagesView(_ pMsg: CANMessage) -> Bool{
        /* Look if the message already exists */
        var lFound: Bool = false
        for element in mRxMessages {
            if(element.ID == pMsg.ID) {
                /** We found the message in the list.
                 * Thus, we update it.
                 */
                element.ID = pMsg.ID
                element.size = pMsg.size
                element.data = pMsg.data
                element.type = pMsg.type
                element.flags = pMsg.flags

                /* TODO : Calculate period */
                element.period = Float(((pMsg.millis - element.millis)*1000 + (pMsg.micros - element.micros))) / 1000.0

                element.isRx = pMsg.isRx
                element.millis = pMsg.millis
                element.millisOverflow = pMsg.millisOverflow
                element.micros = pMsg.micros

                lFound = true
                break
            }
        }

        if(!lFound) {
            pMsg.period = 0.0
            mRxMessages.append(pMsg)
        }

        return true
    }

    fileprivate func updateTxMessagesView(_ pMsg: CANMessage) -> Bool{
        /* Look if the message already exists */

        pMsg.period = 0.0
        mRxMessages.append(pMsg)

        return true
    }
}

extension MessagesViewController: NSTableViewDataSource {

    func numberOfRows(in pTableView: NSTableView) -> Int {
        if(pTableView == mRxMsgTableView) {
            return mRxMessages.count
        } else if(pTableView == mTxMsgTableView) {
            return mTxMessages.count
        } else {
            return 0
        }
    }
}

extension MessagesViewController: NSTableViewDelegate {
    fileprivate enum RxCellIdentifiers {
        static let MsgIDCell = "MsgIDCellID"
        static let DataCell = "MsgDataCellID"
        static let FlagsCell = "MsgFlagsCellID"
        static let PeriodCell = "MsgPeriodCellID"
    }

    fileprivate enum TxCellIdentifiers {
        static let MsgIDCell = "MsgIDCellID"
        static let DataCell = "MsgDataCellID"
        static let FlagsCell = "MsgFlagsCellID"
        static let PeriodCell = "MsgPeriodCellID"
        static let ActiveCell = "MsgSyncSendActiveCellID"
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var lImage: NSImage?
        var lText: String = String()
        var lCellIdentifier: String = String()

        let lDateFormatter = DateFormatter()
        lDateFormatter.dateStyle = .long
        lDateFormatter.timeStyle = .long

        /* If there is no data to display, do not display anything */
        var lItem: CANMessage?
        if(mRxMsgTableView == tableView) {
            if(mRxMessages.count > row) {
                lItem = nil
            } else {
                lItem = mRxMessages[row]
            }
        } else if(mTxMsgTableView == tableView) {
            if(mRxMessages.count > row) {
                lItem = nil
            } else {
                lItem = mRxMessages[row]
            }
        }

        /* Set the cell values */
        if(mRxMsgTableView == tableView) {
            if(tableColumn == tableView.tableColumns[0]) {
                /* Setting the information for the COB-ID cell */
                lCellIdentifier = RxCellIdentifiers.MsgIDCell
                lImage = NSImage(named: "right-arrow")
                lText = String(format:"0x%02X", lItem!.ID)
            } else if tableColumn == tableView.tableColumns[1] {
                /* Setting the information for the message data cell */
                lCellIdentifier = RxCellIdentifiers.DataCell
                for i in 0...lItem!.size {
                    lText += String(format:"0x%02X ", lItem!.data[Int(i)])
                }
            } else if tableColumn == tableView.tableColumns[2] {
                /* Setting the information for the Flag cell */
                lCellIdentifier = RxCellIdentifiers.FlagsCell
                lText = String(format: "0x%02X", lItem!.flags)
            } else if tableColumn == tableView.tableColumns[3] {
                /* Setting the information for the message period cell */
                lCellIdentifier = RxCellIdentifiers.PeriodCell
                lText = String(format: "%d", lItem!.period)
            }
        } else if(mTxMsgTableView == tableView) {
            if(tableColumn == tableView.tableColumns[0]) {
                /* Setting the information for the COB-ID cell */
                lCellIdentifier = TxCellIdentifiers.MsgIDCell
                lImage = NSImage(named: "left-arrow")
                lText = String(format:"0x%02X", lItem!.ID)
            } else if tableColumn == tableView.tableColumns[1] {
                /* Setting the information for the message data cell */
                lCellIdentifier = TxCellIdentifiers.DataCell
                for i in 0...lItem!.size {
                    lText += String(format:"0x%02X ", lItem!.data[Int(i)])
                }
            } else if tableColumn == tableView.tableColumns[2] {
                /* Setting the information for the Flag cell */
                lCellIdentifier = TxCellIdentifiers.FlagsCell
                lText = String(format: "0x%02X", lItem!.flags)
            } else if tableColumn == tableView.tableColumns[3] {
                /* Setting the information for the message period cell */
                lCellIdentifier = TxCellIdentifiers.PeriodCell
                lText = String(format: "%d", lItem!.period)
            } else if tableColumn == tableView.tableColumns[4] {
                /* Setting the infromation for the Active cell */
                lCellIdentifier = TxCellIdentifiers.ActiveCell
                lText = "NOT IMPLEMENTED"
            }
        }

        /* Set the information in a cell and return it. */
        if let lCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: lCellIdentifier), owner: nil) as? NSTableCellView {
            lCell.textField?.stringValue = lText
            lCell.imageView?.image = lImage ?? nil
            return lCell
        }
        return nil
    }
}
