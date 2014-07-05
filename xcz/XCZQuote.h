//
//  XCZQuote.h
//  xcz
//
//  Created by 刘志鹏 on 14-7-5.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCZQuote : NSObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic) int author_id;
@property (nonatomic, strong) NSString *author;
@property (nonatomic) int work_id;
@property (nonatomic, strong) NSString *work;

@end
