//
//  XCZDynasty.h
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCZDynasty : NSObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic) int start_year;
@property (nonatomic) int end_year;

@end
