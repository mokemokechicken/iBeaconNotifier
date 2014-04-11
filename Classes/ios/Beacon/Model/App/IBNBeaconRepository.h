//
//  IBNBeaconRepository.h
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/13.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBNBeaconRepositoryProtocol.h"

@interface IBNBeaconRepository : NSObject <IBNBeaconRepositoryProtocol>
+ (IBNBeaconRepository *)configurationWithFilename:(NSString *)fileame bundle:(NSBundle *)bundle;
+ (IBNBeaconRepository *)configurationWithBeaconArray:(NSArray *)beaconArray;
@end

