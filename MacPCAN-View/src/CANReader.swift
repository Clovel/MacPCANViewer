//
//  CANReader.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

class CANReader {
    let mDriver: CANDriver = CANDriver.instance()
    var mRunning: Bool = false
    
    private static var sShared: CANReader = {() -> CANReader in
        let lDriver: CANReader = CANReader()
        
        return lDriver
    }()
    
    public class func instance() -> CANReader {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        //
    }
    
    /* Thread worker function */
    public func run() {
        var lStatus: UInt = 0x0
        var lErrorText: String = String()
        while(mDriver.isInitialized()) {
            /* The thread is running */
            mRunning = true
            
            /* Get the driver's status */
            lStatus = mDriver.status(&lErrorText)
            if (0 < lStatus) {
                let llErrorText = "[ERROR] <CANReader::run> Connection failed : " + lErrorText + " (status = " + String(format:"0x%04X", lStatus) + ")"
                print(llErrorText)
            }
            
            /* Check if the driver is still initialized */
            if(0x4000000 == lStatus) {
                /* The CAN Channel is not initialized ! */
                let llErrorText = "[ERROR] <CANReader::run> Driver is not initialized ! (status = " + String(format:"0x%04X", lStatus) + ")"
                print(llErrorText)
                
                /* Exit the loop */
                /* no use in running the thread if the driver is not initialized */
                break
            }
            
            /* Sleep, to avoid maxing out the CPU usage */
            usleep(100000) /* 100 ms = 100 000 us */
        }
        
        mRunning = false
    }
}
