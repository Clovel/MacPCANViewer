//
//  CANDriverManager.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

class CANDriverManager {
    
    private var mReader: CANReader = CANReader.instance()
    private var mSender: CANSender = CANSender.instance()
    private var mDriver: CANDriver = CANDriver.instance()
    
    private static var sShared: CANDriverManager = {() -> CANDriverManager in
        let lDriver: CANDriverManager = CANDriverManager()
        
        return lDriver
    }()
    
    public class func instance() -> CANDriverManager {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        //
    }
    
    public func connect(pChannel: CANChannels) {
        if(mDriver.isInitialized()) {
            print("[WARN ] CAN driver is already initialized.")
        } else {
//            var lErrorStr: String = String()
//            var lStatus: UInt
//            
//            lStatus = mDriver.initDriver(pChannel: pChannel, pErrorStr: &lErrorStr)
//            if(0 < lStatus) {
//                print("[ERROR] <CANDriverManager::connect> initDriver failed : " + lErrorStr)
//            }
        }
    }
}
