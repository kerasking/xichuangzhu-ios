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
        [quote loadFromResultSet:s];
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
            [quote loadFromResultSet:s];
            quotes[index] = quote;
            index++;
        }
        
        [db close];
    }
    
    return quotes;
}

- (void)loadFromResultSet:(FMResultSet *)resultSet
{
    self.id = [resultSet intForColumn:@"id"];
    self.quote = [resultSet stringForColumn:@"quote"];
    self.authorId = [resultSet intForColumn:@"author_id"];
    self.author = [resultSet stringForColumn:@"author"];
    self.workId = [resultSet intForColumn:@"work_id"];
    self.work = [resultSet stringForColumn:@"work"];
}

@end
