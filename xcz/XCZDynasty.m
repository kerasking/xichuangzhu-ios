//
//  XCZDynasty.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZDynasty.h"
#import <FMDB/FMDB.h>

@implementation XCZDynasty

+ (NSMutableArray *)getNames
{
    int index = 0;
    NSMutableArray *dynastyNames = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM dynasties ORDER BY start_year ASC"];
        while ([s next]) {
            NSString* dynastyName = [s stringForColumn:@"name"];
            dynastyNames[index] = dynastyName;
            index++;
        }
    }
    
    return dynastyNames;
}

@end
