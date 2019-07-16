//
//  ViewController.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Cocoa
import Darwin

class MessagesViewController: NSViewController {
    
    var mCANDriverManager: CANDriverManager = CANDriverManager.instance()

    var mCANReader: CANReader = CANReader.instance()
    var mCANSender: CANSender = CANSender.instance()

    var mSeekRxMessagesRunning: Bool = false
    var mSeekTxMessagesRunning: Bool = false

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

        /* Start looking for RxMessages */
        seekRxMessages()

        /* Start looking for TxMessages */
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
    
    public func seekRxMessages() {
        if(mSeekRxMessagesRunning) {
            print("[ERROR] <MessagesViewController::seekRxMessages> The CANReader is already running!")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }

            print("[DEBUG] <MessagesViewController::seekRxMessages> Message update thread launched !")

            #if DEBUG
            let lTestMsg: CANMessage = CANMessage()
            lTestMsg.ID = 0x998
            lTestMsg.size = 8
            lTestMsg.data = [0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10]
            lTestMsg.flags = 0xFEDCBA98
            lTestMsg.period = 99.9
            if(self.mCANReader.mRxMsgFifo.put(lTestMsg)) {
                print("[DEBUG] <MessagesViewController::seekRxMessages> A test message has been inserted in the RxFifo")
                _ = lTestMsg.print(true)
            }
            #endif /* DEBUG */

            while(true) {
                self.mSeekRxMessagesRunning = true
                while(self.mCANReader.running()) {
                    /* Check if any message are available in the Rx queue */
                    #if DEBUG
//                    var lAddedMsg: Bool = false
                    #endif /* DEBUG */
                    while(self.mCANReader.messageAvailable()) {
                        /* Get the message */
                        print("[DEBUG] <MessagesViewController::seekRxMessages> A Rx message is available !")
                        let lMsg: CANMessage = self.mCANReader.getMessage()!

                        /* Insert it in the table view */
                        let lSuccess: Bool = self.updateRxMessages(lMsg)
                        if(!lSuccess) {
                            print("[ERROR] <MessagesViewController::seekRxMessages> updateRxMessagesView failed !")
                        } else {
                        #if DEBUG
                            //lAddedMsg = true
                        #endif /* DEBUG */
                        }
                    }
                    #if DEBUG
//                    if(lAddedMsg) {
//                        for i in 0..<self.mRxMessages.count {
//                            _ = self.mRxMessages[i].print(true)
//                        }
//                    }
                    #endif /* DEBUG */
                }

                /* Sleep, to avoid maxing out the CPU usage */
                usleep(100_000) /* 100 ms = 100 000 us */
            }

            self.mSeekRxMessagesRunning = false
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }

            print("[DEBUG] <MessagesViewController::seekRxMessages> GUI update thread launched !")

            while(true) {
                /* Sleep, to avoid maxing out the CPU usage */
                usleep(100_000) /* 100 ms = 100 000 us */

                DispatchQueue.main.async {
                    if(0 < self.mRxMessages.count) {
                        /* Reload GUI */
                        self.reloadRxMessageList()
                    }
                }
            }
        }
    }


    fileprivate func updateRxMessages(_ pMsg: CANMessage) -> Bool{
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
                element.period = Float( ((Int(pMsg.millis) - Int(element.millis))*1000) + (Int(pMsg.micros) - Int(element.micros))) / 1000

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
                lItem = mRxMessages[row]
            } else {
                lItem = nil
            }
        } else if(mTxMsgTableView == tableView) {
            if(mTxMessages.count > row) {
                lItem = mTxMessages[row]
            } else {
                lItem = nil
            }
        }

        /* Set the cell values */
        if(nil != lItem) {
            if(mRxMsgTableView == tableView) {
                if(tableColumn == tableView.tableColumns[0]) {
                    /* Setting the information for the COB-ID cell */
                    lCellIdentifier = RxCellIdentifiers.MsgIDCell
                    lImage = NSImage(named: "right-arrow")
                    lText = String(format:"0x%02X", lItem!.ID)
                } else if tableColumn == tableView.tableColumns[1] {
                    /* Setting the information for the message data cell */
                    lCellIdentifier = RxCellIdentifiers.DataCell
                    for i in 0..<lItem!.size {
                        lText += String(format:"0x%02X ", lItem!.data[Int(i)])
                    }
                } else if tableColumn == tableView.tableColumns[2] {
                    /* Setting the information for the Flag cell */
                    lCellIdentifier = RxCellIdentifiers.FlagsCell
                    lText = String(format: "0x%08X", lItem!.flags)
                } else if tableColumn == tableView.tableColumns[3] {
                    /* Setting the information for the message period cell */
                    lCellIdentifier = RxCellIdentifiers.PeriodCell
                    lText = String(format: "%.3f", lItem!.period)
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
                    for i in 0..<lItem!.size {
                        lText += String(format:"0x%02X ", lItem!.data[Int(i)])
                    }
                } else if tableColumn == tableView.tableColumns[2] {
                    /* Setting the information for the Flag cell */
                    lCellIdentifier = TxCellIdentifiers.FlagsCell
                    lText = String(format: "0x%08X", lItem!.flags)
                } else if tableColumn == tableView.tableColumns[3] {
                    /* Setting the information for the message period cell */
                    lCellIdentifier = TxCellIdentifiers.PeriodCell
                    lText = String(format: "%.3f", lItem!.period)
                } else if tableColumn == tableView.tableColumns[4] {
                    /* Setting the infromation for the Active cell */
                    lCellIdentifier = TxCellIdentifiers.ActiveCell
                    lText = "NOT IMPLEMENTED"
                }
            }

            /* Set the information in a cell and return it. */
            if let lCell: NSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: lCellIdentifier), owner: nil) as? NSTableCellView {
                lCell.textField?.stringValue = lText
                lCell.imageView?.image = lImage ?? nil
                lCell.textField?.toolTip = lText
                lCell.textField?.autoresizesSubviews = true
                //lCell.textField?.
                return lCell
            }
        }
        return nil
    }
}
