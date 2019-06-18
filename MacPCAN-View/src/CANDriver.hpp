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
        
        /* Setters */
        
        /* CAN bus manipulation */
        int init(const unsigned short &pChannel);
        int send(const can_msg_t &pMsg);
        int read(can_msg_t &pMsg);
        
    private:
        CANDriver();
        
    };
}

#endif /* CANDriver_hpp */
