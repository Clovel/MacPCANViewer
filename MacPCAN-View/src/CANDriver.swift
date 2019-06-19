//
//  CANDriver.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

enum CANChannels: UInt16 {
    case CHANNEL_NONE = 0
    case CHANNEL_USBBUS1 = 1
    case CHANNEL_USBBUS2 = 2
    case CHANNEL_USBBUS3 = 3
    case CHANNEL_USBBUS4 = 4
    case CHANNEL_USBBUS5 = 5
    case CHANNEL_USBBUS6 = 6
    case CHANNEL_USBBUS7 = 7
    case CHANNEL_USBBUS8 = 8
}

enum CANDriverLocales: UInt16 {
    case PCBUSB_LOCAL_NEUTRAL = 0x00
    case PCBUSB_LOCAL_GERMAN  = 0x07
    case PCBUSB_LOCAL_ENGLISH = 0x09
    case PCBUSB_LOCAL_SPANISH = 0x0A
    case PCBUSB_LOCAL_ITALIAN = 0x10
    case PCBUSB_LOCAL_FRENCH  = 0x1C
}

fileprivate func getErrorText(pStatus: UInt) -> String {
    let lBufferPtr: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.allocate(capacity: 1024)
    
    let _: UInt = CAN_GetErrorText(pStatus, CANDriverLocales.PCBUSB_LOCAL_ENGLISH.rawValue, lBufferPtr)
    
    let lStr: String = String(cString: lBufferPtr)
    print("[DEBUG] <CANDriver.swift::getErrorText> lStr = " + lStr)
    
    return lStr
}

class CANDriver {
    private var mChannel: CANChannels
    
    init() {
        mChannel = CANChannels.CHANNEL_NONE
    }
    
    public func isInitialized() -> Bool {
        return CANChannels.CHANNEL_NONE == mChannel ? false : true
    }
    
    public func channel() -> UInt16 {
        return mChannel.rawValue
    }
    
    public func initDriver(pChannel: UInt16, pErrorStr: inout String) -> UInt {
        let lStatus: UInt = CAN_Initialize(pChannel, UInt16(PCAN_BAUD_1M), UInt8(PCAN_USB), 0, 0) /* Args 3, 4, 5 are not used w/ PCAN-USB */
        if(0 < lStatus) {
            pErrorStr = getErrorText(pStatus: lStatus)
        }
        
        return lStatus
    }
    
    public func send(pMsg: TPCANMsg, pErrorStr: inout String) -> UInt {
        var lMsg: TPCANMsg = pMsg /* Copy to avoid having to put inout to pMsg */
        let lPtr: UnsafeMutablePointer<TPCANMsg> = withUnsafeMutablePointer(to: &lMsg) { $0 }
        
        let lStatus: UInt = CAN_Write(mChannel.rawValue, lPtr)
        if(0 < lStatus) {
            pErrorStr = getErrorText(pStatus: lStatus)
        }
        
        return lStatus
    }
    
    public func read(pMsg: inout TPCANMsg, pTimeStamp: inout TPCANTimestamp, pErrorStr: inout String) -> UInt {
        let lMsgPtr: UnsafeMutablePointer<TPCANMsg>      = withUnsafeMutablePointer(to: &pMsg) { $0 }
        let lTSPtr: UnsafeMutablePointer<TPCANTimestamp> = withUnsafeMutablePointer(to: &pTimeStamp) { $0 }
        
        let lStatus: UInt = CAN_Read(mChannel.rawValue, lMsgPtr, lTSPtr)
        if(0 < lStatus) {
            pErrorStr = getErrorText(pStatus: lStatus)
        }
        
        return lStatus
    }
}

