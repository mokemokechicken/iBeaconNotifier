//
//  IBNBeaconService.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNBeaconService.h"
#import "IBNBeaconRepositoryProtocol.h"
#import "IBNBeaconRepository.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconModel.h"
#import "IBNNearestModel.h"
#import "IBNBeacon.h"

@interface IBNBeaconService ()
@property id<IBNBeaconRepositoryProtocol> beaconRepository;
@property IBNBLEEventService *bleService;
@property IBNNearestModel *nearestModel;
@property NSMutableArray *beaconModelArray;
@end

@implementation IBNBeaconService
+ (IBNBeaconService *)startWithBeaconRepository:(id<IBNBeaconRepositoryProtocol>)beaconRepository {
    IBNBeaconService *obj = [[IBNBeaconService alloc] init];
    [obj configWithBeaconRepository:beaconRepository];
    return obj;
}

+ (IBNBeaconService *)startWithFielname:(NSString *)filename bundle:(NSBundle *)bundle {
    IBNBeaconRepository *repo = [IBNBeaconRepository configurationWithFilename:filename bundle:bundle];
    return [self startWithBeaconRepository:repo];
}

- (void)configWithBeaconRepository:(id<IBNBeaconRepositoryProtocol>)beaconRepository {
    self.nearestModel = [[IBNNearestModel alloc] init];
    self.beaconModelArray = [NSMutableArray array];
    for (IBNBeacon *beacon in [beaconRepository beacons]) {
        IBNBeaconModel *beaconModel = [[IBNBeaconModel alloc] initWithBeaconId:beacon.beaconId];
        [self.beaconModelArray addObject:beaconModel];
    }
    self.bleService = [IBNBLEEventService configWithBeaconRepository:beaconRepository];
}

- (void)start {
    [self.nearestModel startListenEvent];
    for (IBNBeaconModel *beaconModel in self.beaconModelArray) {
        [beaconModel startListenEvent];
    }
    [self.bleService startMonitoring];
}

- (void)stop {
    [self.nearestModel stopListenEvent];
    for (IBNBeaconModel *beaconModel in self.beaconModelArray) {
        [beaconModel stopListenEvent];
    }
    [self.bleService stopMonitoring];
}

- (void)dealloc {
    [self stop];
}

@end
