//
//  CANDriver.cpp
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

#include "CANDriver.hpp"

#include <PCBUSB.h>

namespace CAN {
    CANDriver::CANDriver() {
        /* Empty */
    }
    
    CANDriver::~CANDriver() {
        /* Empty */
    }
    
    CANDriver &CANDriver::instance(void) {
        static CANDriver sInstance;
        
        return sInstance;
    }
    
    int CANDriver::init(const unsigned short &pChannel) {
        unsigned long lStatus = CAN_Initialize(pChannel, PCAN_BAUD_1M);
        
        return lStatus;
    }
    
    /* Getters */
    
    /* Setters */
    
    /* CAN bus manipulation */
    int CANDriver::send(const can_msg_t &pMsg) {
        //
        return 0;
    }
    
    int CANDriver::read(can_msg_t &pMsg) {
        //
        return 0;
    }
}
