//
//  XCZWork.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-29.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWork.h"
#import <FMDB/FMDB.h>

@implementation XCZWork

// 根据id获取作品
+ (XCZWork *)getById:(int)workId
{
    XCZWork *work = [[XCZWork alloc] init];
    
    // 从SQLite中加载work
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:[[NSString alloc] initWithFormat:@"SELECT * FROM works where id == %d", workId]];
        [s next];
        work.id = [s intForColumn:@"id"];
        work.title = [s stringForColumn:@"title"];
        work.authorId = [s intForColumn:@"author_id"];
        work.author = [s stringForColumn:@"author"];
        work.dynasty = [s stringForColumn:@"dynasty"];
        work.kind = [s stringForColumn:@"kind"];
        work.kindCN = [s stringForColumn:@"kind_cn"];
        work.foreword = [s stringForColumn:@"foreword"];
        work.content = [s stringForColumn:@"content"];
        work.intro = [s stringForColumn:@"intro"];
        work.layout = [s stringForColumn:@"layout"];
        
        [db close];
    }
    
    return work;
}

// 获取所有作品
+ (NSMutableArray *)getAll
{
    int index = 0;
    NSMutableArray *works = [[NSMutableArray alloc] init];

    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM works"];
        while ([s next]) {
            XCZWork *work = [[XCZWork alloc] init];
            work.id = [s intForColumn:@"id"];
            work.title = [s stringForColumn:@"title"];
            work.fullTitle = [s stringForColumn:@"full_title"];
            work.authorId = [s intForColumn:@"author_id"];
            work.author = [s stringForColumn:@"author"];
            work.dynasty = [s stringForColumn:@"dynasty"];
            work.kind = [s stringForColumn:@"kind"];
            work.kindCN = [s stringForColumn:@"kind_cn"];
            work.foreword = [s stringForColumn:@"foreword"];
            work.content = [s stringForColumn:@"content"];
            work.intro = [s stringForColumn:@"intro"];
            work.layout = [s stringForColumn:@"layout"];
            works[index] = work;
            index++;
        }
        
        [db close];
    }
    
    return works;
}

// 获取某文学家的某类文学作品
+ (NSMutableArray *)getWorksByAuthorId:(int)authorId kind:(NSString *)kind
{
    int index = 0;
    NSMutableArray *works = [[NSMutableArray alloc] init];
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM works WHERE author_id = %d AND kind_cn = '%@'", authorId, kind];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            XCZWork *work = [[XCZWork alloc] init];
            work.id = [s intForColumn:@"id"];
            work.title = [s stringForColumn:@"title"];
            work.fullTitle = [s stringForColumn:@"full_title"];
            work.authorId = [s intForColumn:@"author_id"];
            work.author = [s stringForColumn:@"author"];
            work.dynasty = [s stringForColumn:@"dynasty"];
            work.kind = [s stringForColumn:@"kind"];
            work.kindCN = [s stringForColumn:@"kind_cn"];
            work.foreword = [s stringForColumn:@"foreword"];
            work.content = [s stringForColumn:@"content"];
            work.intro = [s stringForColumn:@"intro"];
            work.layout = [s stringForColumn:@"layout"];
            works[index] = work;
            index++;
        }
        
        [db close];
    }
    
    return works;
}

@end
