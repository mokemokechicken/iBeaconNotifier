//
//  IBNNearestModel.m
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/12.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNBLEEventService.h"
#import "IBNBeaconServiceConst.h"
#import "IBNNearestModel.h"

@interface IBNNearestModel ()
@property NSMutableSet *beaconSet;
@property NSString *nearestBeaconId;
@end


@implementation IBNNearestModel

- (id)init {
    self = [super init];
    if (self) {
        self.beaconSet = [NSMutableSet set];
        self.nearestBeaconId = nil;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventNearest:) name:IBN_IBEACON_EVENT_NEAREST object:nil];
}

- (void)eventIn:(NSNotification *)note   {
    NSString *beaconId = note.userInfo[IBN_BEACON_ID];
    if (beaconId) {
        [_beaconSet addObject:beaconId];
    }
    if ([_beaconSet count] == 1) {
        [self decideNearestByBeaconId:[_beaconSet anyObject]];
    }
}

- (void)eventOut:(NSNotification *)note  {
    NSString *beaconId = note.userInfo[IBN_BEACON_ID];
    if (beaconId) {
        [_beaconSet removeObject:beaconId];
    }
    if ([_beaconSet count] == 1) {
        [self decideNearestByBeaconId:[_beaconSet anyObject]];
    } else if ([_beaconSet count] == 0 ){
        [self decideNearestByBeaconId:nil];

    }
}

- (void)eventNearest:(NSNotification *)note {
    NSString *beaconId = note.userInfo[IBN_BEACON_ID];
    [self decideNearestByBeaconId:beaconId];
}

- (void)decideNearestByBeaconId:(NSString *)beaconId {
    if (![beaconId isEqualToString:self.nearestBeaconId]) {
        self.nearestBeaconId = beaconId;
        [self notify];
    }
}

#pragma mark -- Notify
- (void)notify {
    id data = self.nearestBeaconId ? self.nearestBeaconId : [NSNull null];
//    DDLogDebug(@"IBNNearestModel: Notify: beaconId=%@", data);
    [[NSNotificationCenter defaultCenter] postNotificationName:IBN_CHANGE_NEAREST_BEACON object:self
                                                      userInfo:@{IBN_BEACON_ID: data}];
}

@end
