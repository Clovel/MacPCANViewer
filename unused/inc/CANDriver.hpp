//
//  CANDriver.hpp
//  MacPCAN-View
//
//  Created by Clovis Durand on 18/06/2019.
//  Copyright © 2019 Clovis Durand. All rights reserved.
//

#ifndef CANDriver_hpp
#define CANDriver_hpp

#include "CANMessage.hpp"

#include <stdio.h>

namespace CAN {
    class CANDriver {
    public:
        virtual ~CANDriver();
        
        static CANDriver &instance(void);
        
        /* Getters */
        bool isInitialized(void) const;
        uint16_t channel(void) const;
        
        /* Setters */
        
        /* CAN bus manipulation */
        uint32_t init(const unsigned short &pChannel);
        uint32_t send(const can_msg_t &pMsg);
        uint32_t read(can_msg_t &pMsg, can_rx_timestamp_t &pTimeStamp);
        
    private:
        CANDriver();
        uint16_t mChannel;
    };
}

#endif /* CANDriver_hpp */
