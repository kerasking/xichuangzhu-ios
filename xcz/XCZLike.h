//
//  XCZLike.h
//  xcz
//
//  Created by 刘志鹏 on 15/1/1.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCZLike : NSObject

@property (nonatomic) int id;
@property (nonatomic) int workId;
@property (nonatomic, strong) NSString *createdAt;

+ (NSMutableArray *)getAll;
+ (bool)like:(int)workId;
+ (bool)unlike:(int)workId;
+ (bool)checkExist:(int)workId;
+ (int)getMaxShowOrder;

@end
