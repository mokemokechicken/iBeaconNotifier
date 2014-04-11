//
//  IBNBeaconModel.h
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/12.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//
/*
 IBNBeaconModel
    listen BeaconAPI Event
    use IBNBeaconFSM
    emit Notification to 'IBNBeaconStateChange" userInfo=<IBNBeaconState>, IBN_BEACON_KEY

 */

#import <Foundation/Foundation.h>
#import "IBNBeaconFSM.h"


@interface IBNBeaconModel : NSObject
@property (readonly) IBNBeaconFSM *fsm;
@property (readonly) NSString *beaconId;

- (id)initWithBeaconId:(NSString *)beaconId;
- (id)initWithBeaconId:(NSString *)beaconId state:(IBNBeaconModelState *)state;
- (void)cleanUp;
- (void)enterOutside;
- (void)enterInside;
- (void)enterFar;
- (void)enterNear;
@end
