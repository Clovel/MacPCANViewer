//
//  CANMessage.hpp
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

#ifndef CANMessage_hpp
#define CANMessage_hpp

#include <stdio.h>
#include <stdint.h>

#define CAN_DATA_SZ 8U

namespace CAN {
    
    /** @typedef typedef struct can_msg_t
     * @brief This structure defines the CAN message
     */
    typedef struct {
        uint32_t msg_id;
        uint8_t  data_sz;
        uint8_t  data[CAN_DATA_SZ];
        uint8_t  flags;
    } can_msg_t;
    
    /** @typedef typedef struct can_error_level_t
     * @brief This structure defines the CAN bus error levels
     */
    typedef enum _can_error_level {
        CAN_ACTIVE = 0x00, /* When RX- and TX error counters are below 96 */
        CAN_WARNING = 0x40, /* When RX- or TX error counter are between 96 and 127 */
        CAN_PASSIVE = 0x20, /* When RX- or TX error counter are between 128 and 255 */
        CAN_BUS_OFF = 0x80, /* When RX- or TX error counter are above 255 */
    } can_error_level_t;
    
    /** @typedef typedef struct can_error_type_t
     * @brief This structure defines the CAN bus error types
     */
    typedef enum _can_error_type {
        CAN_ERROR_OK = 0, /* When no CAN error occurred */
        CAN_ERROR_STUFF = 1, /* When a stuff error occurred on RX message */
        CAN_ERROR_FORMAT = 2, /* When a form/format error occurred on RX message */
        CAN_ERROR_ACKNOWLEDGE = 3, /* When a TX message wasn't acknowledged */
        CAN_ERROR_BIT1 = 4, /* When a TX message monitored dominant level where recessive is expected */
        CAN_ERROR_BIT0 = 5, /* When a TX message monitored recessive level where dominant is expected */
        CAN_ERROR_CRC = 6, /* When a RX message has wrong CRC value */
        CAN_ERROR_HARDWARE = 7, /* When a tranceiver/hardware error occured */
        CAN_ERROR_NO = 8, /* When no error occurred since last call of this function */
        CAN_ERROR_RECOVERY = 9, /* When no error occurred since last call of this function */
    } can_error_type_t;
}

#endif /* CANMessage_hpp */
