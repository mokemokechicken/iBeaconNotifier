//
//  IBNNearestModelTest.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IBNNearestModel.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconServiceConst.h"

#import "IBNNotificationSpy.h"

@interface IBNNearestModelTest : XCTestCase
@property IBNNearestModel *obj;
@property IBNNotificationSpy *spy;
@end

@implementation IBNNearestModelTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.spy = [[IBNNotificationSpy alloc] init];
    self.obj = [[IBNNearestModel alloc] init];
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

- (void)testSenario1
{
    [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:@"b1"];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"b1", nil]), @"first beacon should be nearest");
    [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:@"b2"];
    XCTAssertEqual(0, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"b2", nil]), @"second beacon should not be nearest");
    [self notifyEvent:IBN_IBEACON_EVENT_OUT beaconId:@"b1"];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"b2", nil]), @"if one beacon exists, it should be nearest");
    [self notifyEvent:IBN_IBEACON_EVENT_OUT beaconId:@"b2"];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"<null>", nil]), @"if no beacon exists, NsNull should be nearest");
    [self notifyEvent:IBN_IBEACON_EVENT_IN beaconId:@"b2"];
    XCTAssertEqual(2, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"b2", nil]), @"first beacon should not be nearest");
    [self notifyEvent:IBN_IBEACON_EVENT_NEAREST beaconId:@"b3"];
    XCTAssertEqual(1, ([self.spy countOf:IBN_CHANGE_NEAREST_BEACON, @"b3", nil]), @"first beacon should not be nearest");
}


@end


