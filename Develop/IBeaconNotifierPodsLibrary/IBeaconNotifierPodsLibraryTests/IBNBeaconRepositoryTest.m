//
//  IBNBeaconRepositoryTest.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/11.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IBNBeaconRepository.h"

@interface IBNBeaconRepositoryTest : XCTestCase
@property IBNBeaconRepository *obj;
@end

@implementation IBNBeaconRepositoryTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.obj = [IBNBeaconRepository configurationWithFilename:@"beacon.csv" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBeaconCount {
    XCTAssertEqual(3, [self.obj.beacons count], @"");
}

- (void)testFirstBeacon {
    id<IBNBeaconProtocol> beacon = self.obj.beacons[0];
    XCTAssertEqualObjects(@"BeaconA", [beacon beaconId], @"");
    XCTAssertEqualObjects(@"4337B720-EA0F-4D15-A2D2-16A41A3691EC", [beacon uuid], @"");
    XCTAssertEqualObjects(@(1), [beacon major], @"");
    XCTAssertEqualObjects(@(2), [beacon minor], @"");
}

@end
