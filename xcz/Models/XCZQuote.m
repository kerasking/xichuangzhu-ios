//
//  XCZQuote.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-5.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZQuote.h"
#import "XCZUtils.h"
#import <FMDB/FMDB.h>

@implementation XCZQuote

// 获取一条随机摘录
+ (XCZQuote *)getRandomQuote
{
    XCZQuote * quote = [[XCZQuote alloc] init];
    
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
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

// 获取一定数目的摘录
+ (NSMutableArray *)getRandomQuotes:(int)number
{
    int index = 0;
    NSMutableArray *quotes = [[NSMutableArray alloc] init];
    
    // 从SQLite中加载数据
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM quotes ORDER BY RANDOM() LIMIT %d", number];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            XCZQuote *quote = [[XCZQuote alloc] init];
            quote.id = [s intForColumn:@"id"];
            quote.quote = [s stringForColumn:@"quote"];
            quote.authorId = [s intForColumn:@"author_id"];
            quote.author = [s stringForColumn:@"author"];
            quote.workId = [s intForColumn:@"work_id"];
            quote.work = [s stringForColumn:@"work"];
            quotes[index] = quote;
            index++;
        }
        
        [db close];
    }
    
    return quotes;
}

@end
