//
//  IBNNotificationSpy.m
//  IBeaconNotifierPodsLibrary
//
//  Created by 森下 健 on 2014/04/14.
//  Copyright (c) 2014年 森下 健. All rights reserved.
//

#import "IBNNotificationSpy.h"
#import "IBNBLEEventService.h"
#import "IBNBeaconServiceConst.h"
#import "IBNBeaconModel.h"


@interface IBNNotificationSpy ()
@property NSMutableDictionary *counter;
@end


@implementation IBNNotificationSpy

- (id)init {
    self = [super init];
    if (self) {
        self.counter = [NSMutableDictionary dictionary];
        [self startWatch];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startWatch {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandle:) name:IBN_CHANGE_NEAREST_BEACON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandle:) name:IBN_CHANGE_BEACON_STATE object:nil];
}

- (void)eventHandle:(NSNotification *)note {
    [self incrCount:note.name];
    if (note.userInfo[IBN_BEACON_ID]) {
        NSString *key = [NSString stringWithFormat:@"%@/%@", note.name, note.userInfo[IBN_BEACON_ID]];
        [self incrCount:key];
    }
    if (note.userInfo[IBN_BEACON_STATE]) {
        NSString *key = [NSString stringWithFormat:@"%@/%@/%@", note.name, note.userInfo[IBN_BEACON_ID], note.userInfo[IBN_BEACON_STATE]];
        [self incrCount:key];
    }
}

- (void)incrCount:(NSString *)key {
    NSNumber *num = self.counter[key];
    if (!num) {
        self.counter[key] = @(1);
    } else {
        self.counter[key] = @([num intValue] + 1);
    }
}

- (int)countOf:(NSString *)key, ...NS_REQUIRES_NIL_TERMINATION {
    va_list args;
    va_start(args, key);
    NSMutableArray *ary = [NSMutableArray array];
    for (NSString *arg = key; arg != nil; arg = va_arg(args, NSString *)) {
        [ary addObject:arg];
    }
    va_end(args);
    
    NSString *realKey = [ary componentsJoinedByString:@"/"];
    NSNumber *num = self.counter[realKey];
    if (num) {
        return [num intValue];
    } else {
        return 0;
    }
}
@end
