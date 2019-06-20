//
//  CANDriver.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 19/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

enum CANChannels: UInt16 {
    case CHANNEL_NONE = 0x00
    case CHANNEL_USBBUS1 = 0x51
    case CHANNEL_USBBUS2 = 0x52
    case CHANNEL_USBBUS3 = 0x53
    case CHANNEL_USBBUS4 = 0x54
    case CHANNEL_USBBUS5 = 0x55
    case CHANNEL_USBBUS6 = 0x56
    case CHANNEL_USBBUS7 = 0x57
    case CHANNEL_USBBUS8 = 0x58
}

enum CANBusBaudrates: UInt16 {
    case CAN_BR_1M     = 0x0014
    case CAN_BR_800K = 0x0016
    case CAN_BR_500K = 0x001C
    case CAN_BR_250K = 0x011C
    case CAN_BR_125K = 0x031C
    case CAN_BR_100K = 0x432F
    case CAN_BR_95K  = 0xC34E
    case CAN_BR_83K  = 0x852B
    case CAN_BR_50K  = 0x472F
    case CAN_BR_47K  = 0x1414
    case CAN_BR_33K  = 0x8B2F
    case CAN_BR_20K  = 0x532F
    case CAN_BR_10K  = 0x672F
    case CAN_BR_5K   = 0x7F7F
}

func canChannelFromString(_ pStr: String) -> CANChannels {
    switch pStr {
    case "CHANNEL_NONE":
        return CANChannels.CHANNEL_NONE
    case "CHANNEL_USBBUS1":
        return CANChannels.CHANNEL_USBBUS1
    case "CHANNEL_USBBUS2":
        return CANChannels.CHANNEL_USBBUS2
    case "CHANNEL_USBBUS3":
        return CANChannels.CHANNEL_USBBUS3
    case "CHANNEL_USBBUS4":
        return CANChannels.CHANNEL_USBBUS4
    case "CHANNEL_USBBUS5":
        return CANChannels.CHANNEL_USBBUS5
    case "CHANNEL_USBBUS6":
        return CANChannels.CHANNEL_USBBUS6
    case "CHANNEL_USBBUS7":
        return CANChannels.CHANNEL_USBBUS7
    case "CHANNEL_USBBUS8":
        return CANChannels.CHANNEL_USBBUS8
    default:
        return CANChannels.CHANNEL_NONE
    }
}

func canChannelToString(_ pChannel: CANChannels) -> String {
    switch pChannel {
    case CANChannels.CHANNEL_NONE:
        return "CHANNEL_NONE"
    case CANChannels.CHANNEL_USBBUS1:
        return "CHANNEL_USBBUS1"
    case CANChannels.CHANNEL_USBBUS2:
        return "CHANNEL_USBBUS2"
    case CANChannels.CHANNEL_USBBUS3:
        return "CHANNEL_USBBUS3"
    case CANChannels.CHANNEL_USBBUS4:
        return "CHANNEL_USBBUS4"
    case CANChannels.CHANNEL_USBBUS5:
        return "CHANNEL_USBBUS5"
    case CANChannels.CHANNEL_USBBUS6:
        return "CHANNEL_USBBUS6"
    case CANChannels.CHANNEL_USBBUS7:
        return "CHANNEL_USBBUS7"
    case CANChannels.CHANNEL_USBBUS8:
        return "CHANNEL_USBBUS8"
//    default: /* Will never be executed, commented to avoid warning */
//        return "CHANNEL_NONE"
    }
}

func canBaudrateFromString(_ pStr: String) -> CANBusBaudrates {
    switch pStr {
    case "CAN_BR_1M":
        return CANBusBaudrates.CAN_BR_1M
    case "CAN_BR_800K":
        return CANBusBaudrates.CAN_BR_800K
    case "CAN_BR_500K":
        return CANBusBaudrates.CAN_BR_500K
    case "CAN_BR_250K":
        return CANBusBaudrates.CAN_BR_250K
    case "CAN_BR_125K":
        return CANBusBaudrates.CAN_BR_125K
    case "CAN_BR_100K":
        return CANBusBaudrates.CAN_BR_100K
    case "CAN_BR_95K":
        return CANBusBaudrates.CAN_BR_95K
    case "CAN_BR_83K":
        return CANBusBaudrates.CAN_BR_83K
    case "CAN_BR_50K":
        return CANBusBaudrates.CAN_BR_50K
    case "CAN_BR_47K":
        return CANBusBaudrates.CAN_BR_47K
    case "CAN_BR_33K":
        return CANBusBaudrates.CAN_BR_33K
    case "CAN_BR_20K":
        return CANBusBaudrates.CAN_BR_20K
    case "CAN_BR_10K":
        return CANBusBaudrates.CAN_BR_10K
    case "CAN_BR_5K":
        return CANBusBaudrates.CAN_BR_5K
    default:
        /* 1M is default value */
        return CANBusBaudrates.CAN_BR_1M
    }
}

func canBaudrateToString(_ pBr: CANBusBaudrates) -> String {
    switch pBr {
    case CANBusBaudrates.CAN_BR_1M:
        return "CAN_BR_1M"
    case CANBusBaudrates.CAN_BR_800K:
        return "CAN_BR_800K"
    case CANBusBaudrates.CAN_BR_500K:
        return "CAN_BR_500K"
    case CANBusBaudrates.CAN_BR_250K:
        return "CAN_BR_250K"
    case CANBusBaudrates.CAN_BR_125K:
        return "CAN_BR_125K"
    case CANBusBaudrates.CAN_BR_100K:
        return "CAN_BR_100K"
    case CANBusBaudrates.CAN_BR_95K:
        return "CAN_BR_95K"
    case CANBusBaudrates.CAN_BR_83K:
        return "CAN_BR_83K"
    case CANBusBaudrates.CAN_BR_50K:
        return "CAN_BR_50K"
    case CANBusBaudrates.CAN_BR_47K:
        return "CAN_BR_47K"
    case CANBusBaudrates.CAN_BR_33K:
        return "CAN_BR_33K"
    case CANBusBaudrates.CAN_BR_20K:
        return "CAN_BR_20K"
    case CANBusBaudrates.CAN_BR_10K:
        return "CAN_BR_10K"
    case CANBusBaudrates.CAN_BR_5K:
        return "CAN_BR_5K"
//    default: /* Will never be executed, commented to avoid warning */
//        /* 1M is default value */
//        return "CAN_BR_1M"
    }
}

enum CANDriverLocales: UInt16 {
    case PCBUSB_LOCAL_NEUTRAL = 0x00
    case PCBUSB_LOCAL_GERMAN  = 0x07
    case PCBUSB_LOCAL_ENGLISH = 0x09
    case PCBUSB_LOCAL_SPANISH = 0x0A
    case PCBUSB_LOCAL_ITALIAN = 0x10
    case PCBUSB_LOCAL_FRENCH  = 0x1C
}

class CANDriver {
    private var mChannel: CANChannels
    
    private static var sShared: CANDriver = {() -> CANDriver in
        let lDriver: CANDriver = CANDriver()
        
        return lDriver
    }()
    
    public class func instance() -> CANDriver {
        return sShared
    }
    
    /* constructor is private, this is a singleton */
    private init() {
        mChannel = CANChannels.CHANNEL_NONE
    }
    
    public func isInitialized() -> Bool {
        return CANChannels.CHANNEL_NONE == mChannel ? false : true
    }
    
    public func channel() -> UInt16 {
        return mChannel.rawValue
    }
    
    private func getErrorText(_ pStatus: UInt) -> String {
        let lBufferPtr: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.allocate(capacity: 1024)
        
        let _: UInt = CAN_GetErrorText(pStatus, CANDriverLocales.PCBUSB_LOCAL_ENGLISH.rawValue, lBufferPtr)
        
        let lStr: String = String(cString: lBufferPtr)
        print("[DEBUG] <CANDriver.swift::getErrorText> lStr = " + lStr + " (status = " + String(format:"0x%04X", pStatus) + ")")
        
        return lStr
    }
    
    public func initDriver(_ pChannel: CANChannels, _ pBaudrate: CANBusBaudrates, _ pErrorStr: inout String) -> UInt {
        let lStatus: UInt = CAN_Initialize(pChannel.rawValue, pBaudrate.rawValue, UInt8(PCAN_USB), 0, 0) /* Args 3, 4, 5 are not used w/ PCAN-USB */
        if(0 < lStatus) {
            pErrorStr = getErrorText(lStatus)
            return lStatus
        }
        
        /* No error occured, save the initialized channel */
        mChannel = pChannel
        
        return lStatus
    }
    
    public func send(_ pMsg: TPCANMsg, _ pErrorStr: inout String) -> UInt {
        var lMsg: TPCANMsg = pMsg /* Copy to avoid having to put inout to pMsg */
        let lPtr: UnsafeMutablePointer<TPCANMsg> = withUnsafeMutablePointer(to: &lMsg) { $0 }
        
        let lStatus: UInt = CAN_Write(mChannel.rawValue, lPtr)
        if(0 < lStatus) {
            pErrorStr = getErrorText(lStatus)
        }
        
        return lStatus
    }
    
    public func read(_ pMsg: inout TPCANMsg, _ pTimeStamp: inout TPCANTimestamp, _ pErrorStr: inout String) -> UInt {
        let lMsgPtr: UnsafeMutablePointer<TPCANMsg>      = withUnsafeMutablePointer(to: &pMsg) { $0 }
        let lTSPtr: UnsafeMutablePointer<TPCANTimestamp> = withUnsafeMutablePointer(to: &pTimeStamp) { $0 }
        
        let lStatus: UInt = CAN_Read(mChannel.rawValue, lMsgPtr, lTSPtr)
        if(0 < lStatus) {
            pErrorStr = getErrorText(lStatus)
        }
        
        return lStatus
    }
    
    public func status(_ pErrorStr: inout String) -> UInt {
        let lStatus: UInt = CAN_GetStatus(mChannel.rawValue)
        if(0 < lStatus) {
            pErrorStr = getErrorText(lStatus)
        }
        
        return lStatus
    }
    
    public func resetQueues(_ pErrorStr: inout String) -> UInt {
        let lStatus: UInt = CAN_Reset(mChannel.rawValue)
        if(0 < lStatus) {
            pErrorStr = getErrorText(lStatus)
        }
        
        return lStatus
    }
}

