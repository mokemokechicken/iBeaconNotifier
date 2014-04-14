//
//  YREBLEController.m
//  RecordEncount
//
//  Created by 森下 健 on 2013/11/14.
//  Copyright (c) 2013年 森下 健. All rights reserved.
//

#import "IBNBeaconServiceConst.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconRepositoryProtocol.h"

#define IBNBLEEventService_GROUP_REGION_ID  (@"IBNBLEEventService_GROUP_REGION_ID")

@interface IBNBLEEventService()
@property id <IBNBeaconRepositoryProtocol> repository;
@property CLLocationManager *locationManager;
@property NSMutableArray *regions;
@end

@implementation IBNBLEEventService

+ (IBNBLEEventService *)configWithBeaconRepository:(id<IBNBeaconRepositoryProtocol>)repository {
    return [[IBNBLEEventService alloc] initWithBeaconRepository:repository];
}

- (id)initWithBeaconRepository:(id <IBNBeaconRepositoryProtocol>)repository
{
    self = [super init];
    if (self) {
        self.repository = repository;
        self.regions = [NSMutableArray array];
        [self initialize];
    }
    return self;
}

-(void)dealloc{
    [self stopMonitoring];
    self.locationManager.delegate = nil;
  
}

-(void)initialize{
    if (!self.locationManager) {
        //LocationManagerの初期化
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
}

-(void)startMonitoring{
    if (self.isMonitoring == YES) {
        return;
    }
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        //CLBeaconRegionが開始できない
//        DDLogWarn(@"Failed start monitoring");
        return;
    }
    
    //CLBeaconRegionを生成し、Beaconによる領域観測を開始
    for (id<IBNBeaconProtocol> beacon in [self.repository beacons]) {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beacon.uuid] major:(CLBeaconMajorValue)[beacon.major intValue] minor:(CLBeaconMinorValue)[beacon.minor intValue] identifier:beacon.beaconId];
        [self.locationManager startMonitoringForRegion:region];
        [self.regions addObject:region];
//        DDLogDebug(@"Start Monitoring Beacon Region: %@", region);
    }
    // グループ的なRegion（距離比較用）の登録: UUIDの一致のみ
    id <IBNBeaconProtocol> beacon = [self.repository beacons][0];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beacon.uuid] identifier:IBNBLEEventService_GROUP_REGION_ID];
    [self.locationManager startMonitoringForRegion:region];
    [self.regions addObject:region];
    //
    self.isMonitoring = YES;
//    DDLogDebug(@"IBNBLEEventService: Start monitoring");
}

-(void)stopMonitoring{
    
    if (self.isMonitoring == NO) {
        return;
    }
    
    //登録したRegionを削除する
    for (id region in self.regions){
        if ([region isMemberOfClass:[CLBeaconRegion class]]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
        }
        if ([region isKindOfClass:[CLRegion class]]) {
            [self.locationManager stopMonitoringForRegion:(CLRegion *) region];
        }
        [self.regions addObject:region];
    }
    
    self.isMonitoring = NO;
//    DDLogInfo(@"IBNBLEEventService: Stop monitoring");
}

- (void)notifyEvent:(NSString *)event beaconId:(NSString *)beaconId {
//    DDLogVerbose(@"IBNBLEEventService: Notify: %@ beaconId=%@", event, beaconId);
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:self
                                                      userInfo:@{IBN_BEACON_ID: beaconId}];
}

#pragma mark -- CLLocationManagerDelegate --

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
//    DDLogInfo(@"IBNBLEEventService: didStartMonitoringForRegion: %@", region);
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
//    DDLogInfo(@"IBNBLEEventService: didDetermineState: %@ state=%ld", region, state);
    switch (state) {
        case CLRegionStateInside:
//            DDLogInfo(@"IBNBLEEventService: didDetermineState as INSIDE");
            [self processInBeaconRegion:region];
            break;
            
        case CLRegionStateOutside:
        case CLRegionStateUnknown:
        default:
//            DDLogInfo(@"IBNBLEEventService: didDetermineState as OUTSIDE");
            break;
            
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    //領域内に侵入した際にコールされる
//    DDLogDebug(@"IBNBLEEventService EnterRegion: %@", region.identifier);
    [self processInBeaconRegion:region];
}

// 領域内にいるときの処理
- (void)processInBeaconRegion:(CLRegion *)region {
    if (![IBNBLEEventService_GROUP_REGION_ID isEqualToString:region.identifier]) { // Group化用のRegion以外なら通知
        [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:region.identifier];
    } else {
        // Group化用のRegionならば、Beaconの距離測定を開始する
        if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    //領域内から退出した際にコールされる
//    DDLogDebug(@"IBNBLEEventService ExitRegion: %@", region.identifier);
    if (![IBNBLEEventService_GROUP_REGION_ID isEqualToString:region.identifier]) { // Group化用のRegion以外なら通知
        [self notifyEvent:IBN_IBEACON_EVENT_OUT beaconId:region.identifier];
    } else {
        // Group化用のRegionならば、Beaconの距離測定を終了する
        if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
        }
    }
}

// Group化用のBeaconRegionの距離測定を開始すると定期的にイベントが呼ばれる
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
//    DDLogVerbose(@"IBNBLEEventService RangeBeacons: %d: %@", (int)beacons.count, beacons);
    // 一番近いBeaconをNearestとして通知
    for (CLBeacon *beacon in beacons) {
        NSString *beaconId = [self getBeaconId:beacon];
        if (beaconId) {
            [self notifyEvent:IBN_IBEACON_EVENT_NEAREST beaconId:beaconId];
            break;
        }
    }

    // それぞれのBeaconを通知
    for (CLBeacon *beacon in beacons) {
        NSString *beaconId = [self getBeaconId:beacon];
        if (!beaconId) {
//            DDLogVerbose(@"IBNBLEEventService Unkown Beacon InRange!!!!!!!: %@", beacon);
            continue;
        }
        switch (beacon.proximity) {
            case CLProximityFar:
                [self notifyEvent:IBN_IBEACON_EVENT_FAR beaconId:beaconId];
                break;

            case CLProximityNear:
                [self notifyEvent:IBN_IBEACON_EVENT_NEAR beaconId:beaconId];
                break;

            case CLProximityImmediate:
                [self notifyEvent:IBN_IBEACON_EVENT_IMMEDIATE beaconId:beaconId];
                break;

            case CLProximityUnknown:
                break;
                
            default:
                break;
        }
    }
}

- (NSString *)getBeaconId:(CLBeacon *)beacon {
    NSString *ret = nil;
    for (id<IBNBeaconProtocol> b in [self.repository beacons]) {
        if ([[beacon.proximityUUID UUIDString] isEqualToString:b.uuid] &&
            [beacon.major intValue] == [b.major intValue] &&
            [beacon.minor intValue] == [b.minor intValue]) {
            ret = b.beaconId;
            break;
        }
    }
    return ret;
}

@end


