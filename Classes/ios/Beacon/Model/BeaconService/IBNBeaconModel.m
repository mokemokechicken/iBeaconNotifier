//
//  IBNBeaconModel.m
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/12.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNBeaconServiceConst.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconModel.h"

@interface IBNBeaconModel ()
@property NSString *beaconId;
@property IBNBeaconFSM *fsm;
@end

@implementation IBNBeaconModel
- (id)initWithBeaconId:(NSString *)beaconId {
    return [self initWithBeaconId:beaconId state:nil];
}

- (id)initWithBeaconId:(NSString *)beaconId state:(IBNBeaconModelState *)state{
    self = [super init];
    if (self) {
        self.beaconId = beaconId;
        if (state) {
            self.fsm = [[IBNBeaconFSM alloc] initWithOwner:self state:state];
        } else {
            self.fsm = [[IBNBeaconFSM alloc] initWithOwner:self];
        }
        [self startListenEvent];
    }
    return self;
}

- (void)dealloc {
    [self cleanUp];
}

- (void)cleanUp {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -- Listen
- (void)startListenEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventIn:) name:IBN_IBEACON_EVENT_IN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventOut:) name:IBN_IBEACON_EVENT_OUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventNear:) name:IBN_IBEACON_EVENT_IMMEDIATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventNear:) name:IBN_IBEACON_EVENT_NEAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventFar:) name:IBN_IBEACON_EVENT_FAR object:nil];
}

- (void)eventIn:(NSNotification *)note   { if ([self isMyBeacon:note]) [_fsm in]; }
- (void)eventOut:(NSNotification *)note  { if ([self isMyBeacon:note]) [_fsm out];}
- (void)eventNear:(NSNotification *)note { if ([self isMyBeacon:note]) [_fsm near];}
- (void)eventFar:(NSNotification *)note  { if ([self isMyBeacon:note]) [_fsm far];}

- (BOOL)isMyBeacon:(NSNotification *)note {
    return [_beaconId isEqualToString:note.userInfo[IBN_BEACON_ID]];
}

#pragma mark -- Notify
- (void)notify: (NSString *)state {
//    DDLogDebug(@"IBNBeaconModel: Notify: %@ beaconId=%@", [state name], self.beaconId);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:IBN_CHANGE_BEACON_STATE
     object:self
     userInfo:@{IBN_BEACON_ID: self.beaconId,
                IBN_BEACON_STATE: state
                }];
}

- (void)enterOutside {
    [self notify:IBN_BEACON_STATE_OUTSIDE];
}

- (void)enterInside {
    [self notify:IBN_BEACON_STATE_INSIDE];
}

- (void)enterFar {
    [self notify:IBN_BEACON_STATE_FAR];
}

- (void)enterNear {
    [self notify:IBN_BEACON_STATE_NEAR];
}
@end
