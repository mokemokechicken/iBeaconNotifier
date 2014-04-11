//
//  IBNBeacon.m
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/13.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNBeacon.h"

@interface IBNBeacon ()
@property NSString *beaconId;
@property NSString *uuid;
@property NSNumber *major;
@property NSNumber *minor;
@end

@implementation IBNBeacon
- (id)initWithBeaconId:(NSString *)beaconId uuid:(NSString *)uuid major:(NSNumber *)major minor:(NSNumber *)minor {
    self = [super init];
    if (self) {
        self.beaconId = beaconId;
        self.uuid = uuid;
        self.major = major;
        self.minor = minor;
    }
    return self;
}
@end
