//
//  IBNBeaconService.h
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBNBeaconRepositoryProtocol;


@interface IBNBeaconService : NSObject
+ (IBNBeaconService *)startWithBeaconRepository:(id <IBNBeaconRepositoryProtocol>)beaconRepository;
+ (IBNBeaconService *)startWithFielname:(NSString *)filename bundle:(NSBundle *)bundle;

- (void)start;
- (void)stop;
@end
