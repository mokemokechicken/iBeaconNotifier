//
//  YREBLEController.h
//  RecordEncount
//
//  Created by 森下 健 on 2013/11/14.
//  Copyright (c) 2013年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

/////////////////////////////////////////////////
// 実際にCoreBluetooth を監視しているObjectが発するNotification
/////////////////////////////////////////////////
// userInfo: @{IBN_BEACON_ID: BeaconID}

// Enter and Exit Event
#define IBN_IBEACON_EVENT_IN         (@"IBN_IBEACON_EVENT_IN")
#define IBN_IBEACON_EVENT_OUT        (@"IBN_IBEACON_EVENT_OUT")

// didRangeBeacons の 各Beaconの状態
#define IBN_IBEACON_EVENT_IMMEDIATE  (@"IBN_IBEACON_EVENT_IMMEDIATE")
#define IBN_IBEACON_EVENT_NEAR       (@"IBN_IBEACON_EVENT_NEAR")
#define IBN_IBEACON_EVENT_FAR        (@"IBN_IBEACON_EVENT_FAR")

// didRangeBeacons のArrayの最初のBeaconIDをセットして通知してください
#define IBN_IBEACON_EVENT_NEAREST    (@"IBN_IBEACON_EVENT_NEAREST")
/////////////////////////////////////////////////



@protocol IBNBeaconRepositoryProtocol;


@interface IBNBLEEventService : NSObject <CLLocationManagerDelegate>

+ (IBNBLEEventService *)configWithBeaconRepository:(id <IBNBeaconRepositoryProtocol>)repository;

-(void)startMonitoring;
-(void)stopMonitoring;

@property BOOL isMonitoring;

@end

