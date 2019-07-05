//
//  CANSender.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

class CANSender {
    private let mDriver: CANDriver = CANDriver.instance()
    private var mRunning: Bool = false

    var mTxMsgFifo: Fifo<CANMessage> = Fifo<CANMessage>(1024)

    private static var sShared: CANSender = {() -> CANSender in
        let lDriver: CANSender = CANSender()
        
        return lDriver
    }()
    
    public class func instance() -> CANSender {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        #if DEBUG
        let lTestMsg: CANMessage = CANMessage()
        lTestMsg.ID = 0x997
        lTestMsg.size = 8
        lTestMsg.data = [0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10]
        lTestMsg.flags = 0xFEDCBA98

        lTestMsg.period = 10.5
        if(mTxMsgFifo.put(lTestMsg)) {
            print("[DEBUG] <CANSender::run> A test message has been inserted in the TxFifo")
            _ = lTestMsg.print(true)
        }
        #endif /* DEBUG */
    }

    public func messageAvailable() -> Bool {
        return 0 < mTxMsgFifo.count
    }

    public func running() -> Bool {
        return mRunning
    }

    /* Thread worker function */
    public func run() {
        if(mRunning) {
            print("[ERROR] <CANSender::run> The CANSender is already running!")
            return
        }

        /* Launch Reader thread */
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }

            print("[DEBUG] <CANSender::run> Thead launched !")

            var lStatus: UInt = 0x0
            var lErrorText: String = String()
            while(self.mDriver.isInitialized()) {
                /* The thread is running */
                self.mRunning = true

                /* Get the driver's status */
                lStatus = self.mDriver.status(&lErrorText)
                if (0 < lStatus) {
                    let llErrorText = "[ERROR] <CANReader::run> Got NOK status : " + lErrorText + " (status = " + String(format:"0x%04X", lStatus) + ")"
                    print(llErrorText)
                }

                /* Check if driver is valid */

                /* Check if the driver is initialized */
                if(0x4000000 == lStatus) {
                    /* The CAN Channel is not initialized ! */
                    let llErrorText = "[ERROR] <CANReader::run> Driver is not initialized ! (status = " + String(format:"0x%04X", lStatus) + ")"
                    print(llErrorText)

                    /* Exit the loop */
                    /* no use in running the thread if the driver is not initialized */
                    break
                }
            }

            /* Exiting thread */
            print("[INFO ] <CANReader::run> Exiting thread...")
            self.mRunning = false

            DispatchQueue.main.async {
                /* Signal the GUI that the thread is no longer running */
            }
        }
    }

    public func getMessage() -> CANMessage? {
        let lMsg: CANMessage? = 0 < mTxMsgFifo.count ? mTxMsgFifo.get() : nil

        if(nil != lMsg) {
            return lMsg
        } else {
            print("[ERROR] <CANSender::getMessage> Internal fifo gave us a NULL object !")
            return nil
        }
    }
}
