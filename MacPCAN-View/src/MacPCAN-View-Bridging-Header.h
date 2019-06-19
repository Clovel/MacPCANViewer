//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>

#import "CANDriver.hpp"

@interface CANDriver : NSObject
@property(nonatomic, readwrite, copy) unsigned short int *channel;
@end

@interface CANDriver ()
@property (nonatomic, readwrite, assign) CAN::CANDriver *driver;
@end

@implementation CANDriver
@synthesize driver = _driver;

-(id)init {
    self = [super init];
    if(self) {
        _driver = CAN::instance();
    }
    if(NULL != _driver) {
        _driver->init();
    }
    return self;
}

-(void)dealloc {
    delete _driver;
}

-(unsigned short int)channel {
    return _driver->channel();
}
