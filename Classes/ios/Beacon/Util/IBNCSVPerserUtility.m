//
//  IBNCSVPerserUtility.m
//  AprilBeacon
//
//  Created by Peromasamune on 2014/03/28.
//  Copyright (c) 2014年 Yumemi Inc. All rights reserved.
//

#import "IBNCSVPerserUtility.h"

//@interface IBNCSVPerserUtility()
//
//+(NSString *)getContentFromBundleWithFileName:(NSString *)filename;
//+(NSArray *)parseCSVDataFromDataString:(NSString *)dataString delimiter:(NSString *)del;
//
//@end

@implementation IBNCSVPerserUtility

#pragma mark -- Class Methid --

+(NSArray *)parseCSVDataFromFilename:(NSString *)filename delimiter:(NSString *)del bundle:(NSBundle *)bundle {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    //    NSString *csvData = [IBNCSVPerserUtility getContentFromBundleWithFileName:fileName];
    NSString *csvData = [IBNCSVPerserUtility getContentFromBundle:bundle filename:filename];
    NSArray *csvArray = [IBNCSVPerserUtility parseCSVDataFromDataString:csvData delimiter:del];
    
    return csvArray;
}

#pragma mark -- Private Method --

+(NSString *)getContentFromBundle:(NSBundle *)bundle filename:(NSString *)filename{
    
    if (!filename || [filename length] == 0) {
        return @"";
    }
    
    NSString *path = [bundle pathForResource:filename ofType:nil];
    if (!path) {
        NSLog(@"%@ is not found in bundle:%@", filename, bundle);
        return @"";
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    if (error) {
        return @"";
    }
    if (!data) {
        return @"";
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return dataString;
}

+(NSArray *)parseCSVDataFromDataString:(NSString *)dataString delimiter:(NSString *)del {
    if (!del) {
        del = @",";
    }
    NSArray *separatedArray = [dataString componentsSeparatedByString:@"\n"];
    
    if ([separatedArray count] == 0) {
        return nil;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *keyArray = [[separatedArray objectAtIndex:0] componentsSeparatedByString:del];
    for (int i = 1; i < [separatedArray count]; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSArray *valueArray = [[separatedArray objectAtIndex:i] componentsSeparatedByString:del];
        if ([valueArray count] < [keyArray count]) {
            continue;
        }
        for (int j = 0; j < [keyArray count]; j++) {
            NSString *key = [keyArray objectAtIndex:j];
            NSString *value = [valueArray objectAtIndex:j];
            [mDic setValue:value forKey:key];
        }
        [dataArray addObject:mDic];
    }
    
    return dataArray;
}

@end
