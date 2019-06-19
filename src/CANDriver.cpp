//
//  CANDriver.cpp
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

#include "CANDriver.hpp"

#include <iostream>

#include <PCBUSB.h>

// Defines ------------------------------------------------
#define PCBUSB_LOCAL_NEUTRAL 0x00
#define PCBUSB_LOCAL_GERMAN 0x07
#define PCBUSB_LOCAL_ENGLISH 0x09
#define PCBUSB_LOCAL_SPANISH 0x0A
#define PCBUSB_LOCAL_ITALIAN 0x10
#define PCBUSB_LOCAL_FRENCH 0x1C

static void canMsgToPCBUSB(const CAN::can_msg_t &in, TPCANMsg &out) {
    out.ID = in.msg_id;
    out.LEN = in.data_sz;
    for(uint8_t i = 0U; out.LEN; ++i) {
        out.DATA[i] = in.data[i];
    }
    out.MSGTYPE = in.flags;
}

static void canMsgFromPCBUSB(const TPCANMsg &in, CAN::can_msg_t &out) {
    out.msg_id = in.ID;
    out.data_sz = in.LEN;
    for(uint8_t i = 0U; out.data_sz; ++i) {
        out.data[i] = in.DATA[i];
    }
    out.flags = in.MSGTYPE; /* TODO : Check if this is true */
}

static void canTimeStampToPCBUSB(const CAN::can_rx_timestamp_t &in, TPCANTimestamp &out) {
    out.millis = in.milliseconds;
    out.millis_overflow = in.milliseconds_overflow;
    out.micros = in.microseconds;
}

static void canTimeStampFromPCBUSB(const TPCANTimestamp &in, CAN::can_rx_timestamp_t &out) {
    out.milliseconds = in.millis;
    out.milliseconds_overflow = in.millis_overflow;
    out.microseconds = in.micros;
}

static uint16_t getErrorText(const TPCANStatus &pStatus, std::string &pErrorText) {
    char lBuffer[1024U]; /* TODO : Find a real value and define it */
    uint32_t lStatus = CAN_GetErrorText(pStatus, PCBUSB_LOCAL_ENGLISH, lBuffer);
    
    pErrorText.erase();
    pErrorText = std::string(lBuffer);

    return lStatus;
}

namespace CAN {
    CANDriver::CANDriver() {
        /* Empty */
    }
    
    CANDriver::~CANDriver() {
        uint32_t lStatus = CAN_Uninitialize(mChannel);
        
        /* TODO : ERROR message */
        if(0U < lStatus) {
            std::string lErrorText;
            (void)getErrorText(lStatus, lErrorText);
            std::cout << "[ERROR] <CANDriver::destructor> CAN_Uninitialize failed : " << lErrorText << std::endl;
        }
        
        mChannel = 0U;
    }
    
    CANDriver &CANDriver::instance(void) {
        static CANDriver sInstance;
        
        return sInstance;
    }
    
    uint32_t CANDriver::init(const unsigned short &pChannel) {
        unsigned long lStatus = CAN_Initialize(pChannel, PCAN_BAUD_1M);
        std::string lErrorMsg;

        if(0U < lStatus) {
            std::string lErrorText;
            (void)getErrorText(lStatus, lErrorText);
            std::cout << "[ERROR] <CANDriver::init> CAN_Initialize failed : " << lErrorText << std::endl;
            return lStatus;
        }
        
        /* TODO : Cover the other error cases */
        
        mChannel = pChannel;
        
        return lStatus;
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
    uint32_t CANDriver::send(const can_msg_t &pMsg) {
        TPCANMsg lMsg;
        canMsgToPCBUSB(pMsg, lMsg);

        uint32_t lStatus = CAN_Write(mChannel, &lMsg);

        if(0U < lStatus) {
            std::string lErrorText;
            (void)getErrorText(lStatus, lErrorText);
            std::cout << "[ERROR] <CANDriver::send> CAN_Initialize failed : " << lErrorText << std::endl;
            //ERROR
            return lStatus;
        }

        return lStatus;
    }
    
    uint32_t CANDriver::read(can_msg_t &pMsg, can_rx_timestamp_t &pTimeStamp) {
        TPCANMsg lMsg;
        TPCANTimestamp lTS;

        uint32_t lStatus = CAN_Read(mChannel, &lMsg, &lTS);

        if(0U < lStatus) {
            std::string lErrorText;
            (void)getErrorText(lStatus, lErrorText);
            std::cout << "[ERROR] <CANDriver::read> CAN_Read failed : " << lErrorText << std::endl;
            //ERROR
            return lStatus;
        }

        canMsgFromPCBUSB(lMsg, pMsg);
        canTimeStampFromPCBUSB(lTS, pTimeStamp);

        return lStatus;
    }
}
