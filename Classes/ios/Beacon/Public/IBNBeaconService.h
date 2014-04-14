//
//  IBNBeaconService.h
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

/* beacon.tsv sample
 
id	uuid	major	minor
BeaconA	4337B720-EA0F-4D15-A2D2-16A41A3691EC	1	2
BeaconB	4337B720-EA0F-4D15-A2D2-16A41A3691EC	1	1
BeaconC	4337B720-EA0F-4D15-A2D2-16A41A3691EC	1	0

*/

#import <Foundation/Foundation.h>

@protocol IBNBeaconRepositoryProtocol;


@interface IBNBeaconService : NSObject

+ (IBNBeaconService *)createWithBeaconRepository:(id <IBNBeaconRepositoryProtocol>)beaconRepository;

// load TSV format file from bundle
+ (IBNBeaconService *)createWithFielname:(NSString *)filename bundle:(NSBundle *)bundle;

- (void)start;
- (void)stop;

@end
