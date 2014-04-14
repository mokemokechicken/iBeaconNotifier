//
//  IBNNearestModel.h
//  IBNStorySample
//
//  Created by 森下 健 on 2014/03/12.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//



#import <Foundation/Foundation.h>


@protocol IBNBeaconRepositoryProtocol;


@interface IBNNearestModel : NSObject
+ (IBNNearestModel *)configWithBeaconRepository: (id <IBNBeaconRepositoryProtocol>)beaconRepository;
- (void)stopListenEvent;
- (void)startListenEvent;
@end
