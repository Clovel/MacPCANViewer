//
//  CANSender.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

class CANSender {
    private static var sShared: CANSender = {() -> CANSender in
        let lDriver: CANSender = CANSender()
        
        return lDriver
    }()
    
    public class func instance() -> CANSender {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        //
    }
}
