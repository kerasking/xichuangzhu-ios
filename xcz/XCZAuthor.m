//
//  XCZAuthor.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZAuthor.h"
#import <FMDB/FMDB.h>

@implementation XCZAuthor

// 根据id获取文学家
+ (XCZAuthor *)getById:(int)authorId
{
    XCZAuthor *author = [[XCZAuthor alloc] init];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM authors WHERE id = %d", authorId];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
            author.id = [s intForColumn:@"id"];
            author.name = [s stringForColumn:@"name"];
            author.intro = [s stringForColumn:@"intro"];
            author.dynasty = [s stringForColumn:@"dynasty"];
            author.birthYear = [s stringForColumn:@"birth_year"];
            author.deathYear = [s stringForColumn:@"death_year"];
        }
        
        [db close];
    }
    
    return author;
}

// 获取某文学家的作品总数
+ (int)getWorksCount:(int)authorId
{
    int worksCount = 0;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT COUNT(*) AS works_count FROM works WHERE author_id = %d", authorId];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
            worksCount = [s intForColumn:@"works_count"];
        }
        
        [db close];
    }
    
    return worksCount;
}

@end
