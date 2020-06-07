//
//  XCZUtils.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-7.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZUtils.h"

@implementation XCZUtils

+ (NSUInteger)currentWindowWidth
{
    // 参考：http://stackoverflow.com/questions/7905432/how-to-get-orientation-dependent-height-and-width-of-the-screen
    NSInteger width = 0;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        width = size.height;
    } else {
        width = size.width;
    }
    
    return width;
}

+ (NSString *)getDatabaseFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *storePath = [documentsDirectory stringByAppendingPathComponent: @"xcz.db"];
    return storePath;
}

+ (NSString *)getUserDatabaseFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *storePath = [documentsDirectory stringByAppendingPathComponent: @"xcz_user.db"];
    return storePath;
}

@end
