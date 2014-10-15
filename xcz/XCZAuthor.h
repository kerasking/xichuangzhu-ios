//
//  XCZAuthor.h
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCZAuthor : NSObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *dynasty;
@property (nonatomic, strong) NSString *birthYear;
@property (nonatomic, strong) NSString *deathYear;

+ (XCZAuthor *)getById:(int)authorId;
+ (int)getWorksCount:(int)authorId;

@end
