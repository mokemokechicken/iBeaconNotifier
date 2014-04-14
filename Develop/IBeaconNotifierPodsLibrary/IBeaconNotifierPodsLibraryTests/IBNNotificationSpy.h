//
//  IBNNotificationSpy.h
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBNNotificationSpy : NSObject
- (int)countOf:(NSString *)key, ...NS_REQUIRES_NIL_TERMINATION;
@end
