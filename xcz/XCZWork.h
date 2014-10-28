//
//  XCZWork.h
//  xcz
//
//  Created by 刘志鹏 on 14-6-29.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCZWork : NSObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *fullTitle;
@property (nonatomic) int authorId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *dynasty;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *kindCN;
@property (nonatomic, strong) NSString *foreword;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *layout;

+ (XCZWork *)getById:(int)workId;
+ (NSMutableArray *)getAll;
+ (NSMutableArray *)getWorksByAuthorId:(int)authorId kind:(NSString *)kind;

@end
