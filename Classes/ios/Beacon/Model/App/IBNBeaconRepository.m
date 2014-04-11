//
//  IBNBeaconRepository.m
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/13.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNBeaconRepository.h"
#import "IBNCSVPerserUtility.h"
#import "IBNBeacon.h"


@interface IBNBeaconRepository ()
@property NSArray *beacons;
@end


@implementation IBNBeaconRepository

+ (IBNBeaconRepository *)configurationWithFilename:(NSString *)filename bundle:(NSBundle *)bundle {
    NSArray *dataArray = [IBNCSVPerserUtility parseCSVDataFromFilename:filename delimiter:@"\t" bundle:bundle];
    NSMutableArray *beaconArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        IBNBeacon *beacon = [[IBNBeacon alloc] initWithBeaconId:dict[@"id"] uuid:dict[@"uuid"]
                                                          major:[NSNumber numberWithInt:[dict[@"major"] intValue]]
                                                          minor:[NSNumber numberWithInt:[dict[@"minor"] intValue]]];
        [beaconArray addObject:beacon];
    }
    return [IBNBeaconRepository configurationWithBeaconArray:beaconArray];
}

+ (IBNBeaconRepository *)configurationWithBeaconArray:(NSArray *)beaconArray {
    IBNBeaconRepository *repo = [[IBNBeaconRepository alloc] init];
    repo.beacons = [beaconArray copy];
    return repo;
}

- (IBNBeacon *)beaconById:(NSString *)beaconId {
    IBNBeacon *ret = nil;
    for (IBNBeacon *beacon in self.beacons) {
        if ([beacon.beaconId isEqualToString:beaconId]) {
            ret = beacon;
            break;
        }
    }
    return ret;
}

@end
