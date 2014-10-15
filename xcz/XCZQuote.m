//
//  XCZQuote.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-5.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZQuote.h"
#import <FMDB/FMDB.h>

@implementation XCZQuote

+ (XCZQuote *)getRandomQuote
{
    XCZQuote * quote = [[XCZQuote alloc] init];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM quotes ORDER BY RANDOM() LIMIT 1"];
        [s next];
        quote.id = [s intForColumn:@"id"];
        quote.quote = [s stringForColumn:@"quote"];
        quote.authorId = [s intForColumn:@"author_id"];
        quote.author = [s stringForColumn:@"author"];
        quote.workId = [s intForColumn:@"work_id"];
        quote.work = [s stringForColumn:@"work"];
        [db close];
    }
    
    return quote;
}

@end
