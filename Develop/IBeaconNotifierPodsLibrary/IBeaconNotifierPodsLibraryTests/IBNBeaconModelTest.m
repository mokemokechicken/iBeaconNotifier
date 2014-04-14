//
//  IBNBeaconModelTest.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IBNBeaconModel.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconServiceConst.h"

#import "IBNNotificationSpy.h"


#define BID     (@"c1")

@interface IBNBeaconModelTest : XCTestCase
@property IBNBeaconModel *obj;
@property IBNNotificationSpy *spy;
@end

@implementation IBNBeaconModelTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.spy = [[IBNNotificationSpy alloc] init];
    self.obj = [[IBNBeaconModel alloc] initWithBeaconId:BID];
}

- (void)tearDown
{
    [self.obj cleanUp];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)notifyEvent:(NSString *)event beaconId:(NSString *)beaconId {
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:nil userInfo:@{IBN_BEACON_ID: beaconId}];
}


- (void)testSenario
{
    [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:@"zz"];
    XCTAssertEqual(0, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, @"zz", IBN_BEACON_STATE_INSIDE, nil]), @"different id must not be counted");

    [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:BID];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_INSIDE, nil]), @"INSIDE");

    [self notifyEvent:IBN_IBEACON_EVENT_FAR beaconId:BID];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_FAR, nil]), @"FAR");

    [self notifyEvent:IBN_IBEACON_EVENT_NEAR beaconId:BID];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_NEAR, nil]), @"NEAR");

    [self notifyEvent:IBN_IBEACON_EVENT_NEAR beaconId:BID];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_NEAR, nil]), @"NEAR Again");

    [self notifyEvent:IBN_IBEACON_EVENT_FAR beaconId:BID];
    XCTAssertEqual(2, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_FAR, nil]), @"FAR2");

    [self notifyEvent:IBN_IBEACON_EVENT_IMMEDIATE beaconId:BID];
    XCTAssertEqual(2, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_NEAR, nil]), @"Immediate");

    [self notifyEvent:IBN_IBEACON_EVENT_OUT beaconId:BID];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_BEACON_STATE, BID, IBN_BEACON_STATE_OUTSIDE, nil]), @"OUT");
}

@end
