//
//  IBNBeaconRepositoryProtocol.h
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/13.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBNBeaconProtocol <NSObject>
@property (readonly) NSString *beaconId;
@property (readonly) NSString *uuid;
@property (readonly) NSNumber *major;
@property (readonly) NSNumber *minor;
- (id)initWithBeaconId:(NSString *)beaconId uuid:(NSString *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;
@end


@protocol IBNBeaconRepositoryProtocol <NSObject>
@property (readonly) NSArray *beacons;
- (id<IBNBeaconProtocol>) beaconById:(NSString *)beaconId;
@end

