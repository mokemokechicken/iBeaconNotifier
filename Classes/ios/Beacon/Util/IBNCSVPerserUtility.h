//
//  IBNCSVPerserUtility.h
//  AprilBeacon
//
//  Created by Peromasamune on 2014/03/28.
//  Copyright (c) 2014年 Yumemi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBNCSVPerserUtility : NSObject

+(NSArray *)parseCSVDataFromFilename:(NSString *)filename delimiter:(NSString *)del bundle:(NSBundle *)bundle;
+(NSArray *)parseCSVDataFromDataString:(NSString *)dataString delimiter:(NSString *)del;
@end
