//
//  CANReader.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

class CANReader {
    private let mDriver: CANDriver = CANDriver.instance()
    private var mRunning: Bool = false

    var mRxMsgFifo: Fifo<CANMessage> = Fifo<CANMessage>(1024)
    
    private static var sShared: CANReader = {() -> CANReader in
        let lDriver: CANReader = CANReader()
        
        return lDriver
    }()
    
    public class func instance() -> CANReader {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        #if DEBUG
        let lTestMsg: CANMessage = CANMessage()
        lTestMsg.ID = 0x999
        lTestMsg.size = 8
        lTestMsg.data = [0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10]
        lTestMsg.flags = 0xFEDCBA98
        if(mRxMsgFifo.put(lTestMsg)) {
            print("[DEBUG] <CANReader::run> A test message has been inserted in the RxFifo")
            _ = lTestMsg.print(true)
        }
        #endif /* DEBUG */
    }

    public func messageAvailable() -> Bool {
        return 0 < mRxMsgFifo.count
    }
    
    public func running() -> Bool {
        return mRunning
    }
    
    /* Thread worker function */
    public func run() {
        if(mRunning) {
            print("[ERROR] <CANReader::run> The CANReader is already running!")
            return
        }

        /* Launch Reader thread */
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }

            print("[DEBUG] <CANReader::run> Thead launched !")
            
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
                
                /* Read the CAN driver */
                var lMsg: TPCANMsg = TPCANMsg(ID: 0x0, MSGTYPE: 0x0, LEN: 0, DATA: (0, 0, 0, 0, 0, 0, 0, 0))
                var lTs: TPCANTimestamp = TPCANTimestamp(millis: 0, millis_overflow: 0, micros: 0)
                
                lStatus = self.mDriver.read(&lMsg, &lTs, &lErrorText)

                /* Translate the message to the CANMessage class model type */
                let lCANMessage: CANMessage = createFromTPCANMsgWithTimeStamp((lMsg, lTs))
                
                if(!self.mRxMsgFifo.put(lCANMessage)) {
                    /* FIFO is full */
                    print("[ERROR] <CANReader::run> Rx FIFO is full, discarding message w/ ID " + String(format: "0x%3X", lCANMessage.ID) +  " !")
                    
                    /* TODO : This section is for debug purposes */
                    break
                } else {
                    print("[DEBUG] <CANReader::run> Put message in Rx FIFO, has ID " + String(format: "0x%3X", lMsg.ID))
                }
                
                /* Sleep, to avoid maxing out the CPU usage */
                //usleep(100000) /* 100 ms = 100 000 us */
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
        let lMsg: CANMessage? = 0 < mRxMsgFifo.count ? mRxMsgFifo.get() : nil

        if(nil != lMsg) {
            return lMsg
        } else {
            print("[ERROR] <CANReader::getMessage> Internal fifo gave us a NULL object !")
            return nil
        }
    }
}
