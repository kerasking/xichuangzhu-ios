//
//  XCZUtils.h
//  xcz
//
//  Created by 刘志鹏 on 14-7-7.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于性能测试
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

@interface XCZUtils : NSObject

+ (NSUInteger)currentWindowWidth;
+ (NSString *)getDatabaseFilePath;

@end
