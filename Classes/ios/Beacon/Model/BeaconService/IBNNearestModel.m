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
#import "IBNBeaconRepositoryProtocol.h"


@interface IBNNearestModel ()
@property NSMutableSet *beaconSet;
@property NSString *nearestBeaconId;
@property BOOL isListening;
@property id <IBNBeaconRepositoryProtocol> beaconRepository;
@property NSMutableSet *beaconIdSet;
@end


@implementation IBNNearestModel

+ (IBNNearestModel *)configWithBeaconRepository:(id<IBNBeaconRepositoryProtocol>)beaconRepository {
    IBNNearestModel *model = [[IBNNearestModel alloc] initWithBeaconRepository: beaconRepository];
    return model;
}

- (id)initWithBeaconRepository: (id<IBNBeaconRepositoryProtocol>)beaconRepository {
    self = [super init];
    if (self) {
        self.isListening = false;
        self.beaconSet = [NSMutableSet set];
        self.nearestBeaconId = nil;
        self.beaconRepository = beaconRepository;
        self.beaconIdSet = [NSMutableSet set];
        [self setupBeaconSet];
    }
    return self;
}

- (void)dealloc {
    [self stopListenEvent];
}

- (void)setupBeaconSet {
    for (id <IBNBeaconProtocol> beacon in [self.beaconRepository beacons]) {
        [self.beaconIdSet addObject:[beacon beaconId]];
    }
}

- (void)stopListenEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.isListening = false;
}

#pragma mark -- Listen
- (void)startListenEvent {
    if (!self.isListening) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventIn:) name:IBN_IBEACON_EVENT_IN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventOut:) name:IBN_IBEACON_EVENT_OUT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventNearest:) name:IBN_IBEACON_EVENT_NEAREST object:nil];
        self.isListening = true;
    }
}

- (BOOL)isTargetBeacon:(NSString *)beaconId {
    return [self.beaconIdSet containsObject:beaconId];
}

- (void)eventIn:(NSNotification *)note   {
    NSString *beaconId = note.userInfo[IBN_BEACON_ID];
    if (![self isTargetBeacon:beaconId]) {
        return;
    }
    if (beaconId) {
        [_beaconSet addObject:beaconId];
    }
    if ([_beaconSet count] == 1) {
        [self decideNearestByBeaconId:[_beaconSet anyObject]];
    }
}

- (void)eventOut:(NSNotification *)note  {
    NSString *beaconId = note.userInfo[IBN_BEACON_ID];
    if (![self isTargetBeacon:beaconId]) {
        return;
    }
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
    if (![self isTargetBeacon:beaconId]) {
        return;
    }
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
