//
//  IBNBLEEventService.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IBNBeaconServiceConst.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconRepositoryProtocol.h"
#import "IBNBeaconRepository.h"


@interface IBNBLEEventServiceTest : XCTestCase
@property IBNBLEEventService *obj;
@end

@implementation IBNBLEEventServiceTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    IBNBeaconRepository *repo = [IBNBeaconRepository configurationWithFilename:@"beacon.csv" bundle:[NSBundle bundleForClass:[self class]]];
    self.obj = [IBNBLEEventService configWithBeaconRepository:repo];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // NO TEST
}

@end
