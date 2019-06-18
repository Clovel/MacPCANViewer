//
//  CANDriver.cpp
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

#include "CANDriver.hpp"

#include <iostream>

namespace PCBUSB {
    #include <PCBUSB.h>
}

namespace CAN {
    CANDriver::CANDriver() {
        /* Empty */
    }
    
    CANDriver::~CANDriver() {
        unsigned long lStatus = PCBUSB::CAN_Uninitialize(mChannel);
        
        /* TODO : ERROR message */
        if(0U < lStatus) {
            std::cout << "[ERROR] <CANDriver::init> CAN_Uninitialize failed : Unknown error occured !" << std::endl;
        }
        
        mChannel = 0U;
    }
    
    CANDriver &CANDriver::instance(void) {
        static CANDriver sInstance;
        
        return sInstance;
    }
    
    int CANDriver::init(const unsigned short &pChannel) {
        unsigned long lStatus = PCBUSB::CAN_Initialize(pChannel, PCAN_BAUD_1M);
        
        if(PCAN_ERROR_NODRIVER == (PCAN_ERROR_NODRIVER & lStatus)) {
            std::cout << "[ERROR] <CANDriver::init> CAN_Initialize failed : No CAN driver is loaded !" << std::endl;
            return 1;
        } else if(0U < lStatus) {
            std::cout << "[ERROR] <CANDriver::init> CAN_Initialize failed : Unknown error occured !" << std::endl;
            return 255;
        }
        
        /* TODO : Cover the other error cases */
        
        mChannel = pChannel;
        
        return 0;
    }
    
    /* Getters */
    bool CANDriver::isInitialized(void) const {
        return 0 != mChannel;
    }
    
    unsigned short CANDriver::channel(void) const {
        return mChannel;
    }
    
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
