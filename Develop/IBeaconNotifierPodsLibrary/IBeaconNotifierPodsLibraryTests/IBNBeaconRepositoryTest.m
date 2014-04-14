//
//  IBNBeaconRepositoryTest.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/11.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IBNBeaconRepository.h"
#import "IBNBeacon.h"

@interface IBNBeaconRepositoryTest : XCTestCase
@property NSArray *objArray;
@end

@implementation IBNBeaconRepositoryTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.objArray = @[[self repositoryConfigWithFilename], [self repositoryConfigWithArray]];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (IBNBeaconRepository *)repositoryConfigWithFilename {
    return [IBNBeaconRepository configurationWithFilename:@"beacon.csv" bundle:[NSBundle bundleForClass:[self class]]];
}

- (IBNBeaconRepository *)repositoryConfigWithArray {
    NSString *uuid = @"4337B720-EA0F-4D15-A2D2-16A41A3691EC";
    NSArray *beaconArray = @[
                             [[IBNBeacon alloc] initWithBeaconId:@"BeaconA" uuid:uuid major:@(1) minor:@(2)],
                             [[IBNBeacon alloc] initWithBeaconId:@"BeaconB" uuid:uuid major:@(1) minor:@(1)],
                             [[IBNBeacon alloc] initWithBeaconId:@"BeaconC" uuid:uuid major:@(1) minor:@(0)],
                             ];
    return [IBNBeaconRepository configurationWithBeaconArray:beaconArray];
}


- (void)testBeaconCount {
    for (IBNBeaconRepository *obj in self.objArray) {
        XCTAssertEqual(3, [obj.beacons count], @"%@", obj);
    }
}

- (void)testFirstBeacon {
    for (IBNBeaconRepository *obj in self.objArray) {
        id<IBNBeaconProtocol> beacon = obj.beacons[0];
        XCTAssertEqualObjects(@"BeaconA", [beacon beaconId], @"");
        XCTAssertEqualObjects(@"4337B720-EA0F-4D15-A2D2-16A41A3691EC", [beacon uuid], @"");
        XCTAssertEqualObjects(@(1), [beacon major], @"");
        XCTAssertEqualObjects(@(2), [beacon minor], @"");
    }
}

- (void)testThirdBeacon {
    for (IBNBeaconRepository *obj in self.objArray) {
        id<IBNBeaconProtocol> beacon = obj.beacons[2];
        XCTAssertEqualObjects(@"BeaconC", [beacon beaconId], @"");
        XCTAssertEqualObjects(@"4337B720-EA0F-4D15-A2D2-16A41A3691EC", [beacon uuid], @"");
        XCTAssertEqualObjects(@(1), [beacon major], @"");
        XCTAssertEqualObjects(@(0), [beacon minor], @"");
    }
}

@end
