//
//  CANMessage.swift
//  MacPCAN-View
//
//  Created by Clovis Durand on 04/07/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

import Foundation

/* PCAN message types
 */
enum CANMessageType: UInt {
    typealias RawValue = UInt

    case STANDARD = 0x00 //!< The PCAN message is a CAN Standard Frame (11-bit identifier)
    case RTR = 0x01 //!< The PCAN message is a CAN Remote-Transfer-Request Frame
    case EXTENDED = 0x02 //!< The PCAN message is a CAN Extended Frame (29-bit identifier)
    case FD = 0x04 //!< The PCAN message represents a FD frame in terms of CiA Specs
    case BRS = 0x08 //!< The PCAN message represents a FD bit rate switch (CAN data at a higher bit rate)
    case ESI = 0x10 //!< The PCAN message represents a FD error state indicator(CAN FD transmitter was error active)
    case STATUS = 0x80 /* !< The PCAN message represents a PCAN status message */
}

class CANMessage {
    /* Data */
    public var ID: UInt
    public var size: UInt
    public var data: [UInt]
    public var type: CANMessageType
    public var flags: UInt

    /* Timestamp data for RxMessages */
    public var isRx: Bool
    public var millis: UInt
    public var millisOverflow: UInt
    public var micros: UInt

    public var period: Float

    public init() {
        ID = 0x0
        size = 0
        data = [UInt]()
        type = CANMessageType.STANDARD
        flags = 0x0

        isRx = false
        millis = 0
        millisOverflow = 0
        micros = 0

        period = 0
    }

    public func print(_ pOutput: Bool) -> String {
        var lStr: String = ""
        if(isRx) {
            lStr += "> Rx : "
        } else {
            lStr += "< Tx : "
        }

        lStr += String(format: "ID: 0x%02X ", ID)
        lStr += String(format: "Size: %d ", size)

        lStr += "["
        for i in 0..<size {
            //lStr += String(format:"0x%02X ", data[Int(i)])
            if(size - 1 > i) {
                lStr += String(format:"0x%02X ", data[Int(i)])
            } else {
                lStr += String(format:"0x%02X", data[Int(i)])
            }
        }
        lStr += "] "
        lStr += String(format: "Flags: 0x%08X", flags)

        if(pOutput) {
            Swift.print(lStr)
        }

        return lStr
    }
}

fileprivate func arrayFromTuple<T,R>(pTuple: T) -> [R] {
    let lReflection = Mirror(reflecting: pTuple)
    var lArray: [R] = []
    for i in lReflection.children {
        /* TODO : Better will be to throw an Error if i.value is not R */
        lArray.append(i.value as! R)
    }

    return lArray
}

func createFromTPCANMsg(_ pCANMsg: TPCANMsg) -> CANMessage {

    let lMsg: CANMessage = CANMessage()
    lMsg.ID = pCANMsg.ID
    lMsg.size = UInt(pCANMsg.LEN)
    let lCDataArray: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = pCANMsg.DATA
    let lTempArray: [UInt8] = arrayFromTuple(pTuple: lCDataArray)
    for i in 0..<Int(lMsg.size) {
        lMsg.data.append(UInt(lTempArray[i]))
    }
    lMsg.type = CANMessageType(rawValue: UInt(pCANMsg.MSGTYPE))!

    return lMsg
}

func createFromTPCANMsgWithTimeStamp(_ pCANMsg: (TPCANMsg, TPCANTimestamp)) -> CANMessage {

    let lMsg: CANMessage = createFromTPCANMsg(pCANMsg.0)

    lMsg.isRx = true
    lMsg.millis = pCANMsg.1.millis
    lMsg.millisOverflow = UInt(pCANMsg.1.millis_overflow)
    lMsg.micros = UInt(pCANMsg.1.micros)

    return lMsg
}

func convertToTPCANMsg(_ pCANMsg: CANMessage) -> TPCANMsg {
    var lMsg: TPCANMsg = TPCANMsg()

    lMsg.ID = pCANMsg.ID
    lMsg.LEN = UInt8(pCANMsg.size)
    lMsg.MSGTYPE = UInt8(pCANMsg.type.rawValue)

/* TODO : I must find a better way to do this... */
    if(1 == lMsg.LEN) {
        lMsg.DATA.0 = UInt8(pCANMsg.data[0])
    } else if(2 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[1])
    } else if(3 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[2])
    } else if(4 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[3])
    } else if(5 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[4])
    } else if(6 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[5])
    } else if(7 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[6])
    } else if(8 == lMsg.LEN) {
        lMsg.DATA.1 = UInt8(pCANMsg.data[7])
    } else {
        /* ERROR */
        print("[ERROR] <convertToTPCANMsg> Message length > 8 !")
    }

    return lMsg
}
