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
    public var data:[UInt]
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

func createFromTPCANMsg(_ pCANRxMsg: TPCANMsg) -> CANMessage {

    let lMsg: CANMessage = CANMessage()
    lMsg.ID = pCANRxMsg.ID
    lMsg.size = UInt(pCANRxMsg.LEN)
    let lCDataArray: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = pCANRxMsg.DATA
    lMsg.data = arrayFromTuple(pTuple: lCDataArray)
    lMsg.type = CANMessageType(rawValue: UInt(pCANRxMsg.MSGTYPE))!

    return lMsg
}

func createFromTPCANMsgWithTimeStamp(_ pCANRxMsg: (TPCANMsg, TPCANTimestamp)) -> CANMessage {

    let lMsg: CANMessage = createFromTPCANMsg(pCANRxMsg.0)

    lMsg.isRx = true
    lMsg.millis = pCANRxMsg.1.millis
    lMsg.millisOverflow = UInt(pCANRxMsg.1.millis_overflow)
    lMsg.micros = UInt(pCANRxMsg.1.micros)

    return lMsg
}
