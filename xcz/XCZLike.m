//
//  XCZLike.m
//  xcz
//
//  Created by 刘志鹏 on 15/1/1.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZLike.h"
#import "XCZUtils.h"
#import <FMDB/FMDB.h>

@implementation XCZLike

// 获取所有收藏记录
+ (NSMutableArray *)getAll
{
    int index = 0;
    NSMutableArray *likes = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [XCZUtils getUserDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM likes ORDER BY show_order ASC"];
        while ([s next]) {
            XCZLike *like = [[XCZLike alloc] init];
            like.id = [s intForColumn:@"id"];
            like.workId = [s intForColumn:@"work_id"];
            like.createdAt = [s stringForColumn:@"created_at"];
            likes[index] = like;
            index++;
        }
        
        [db close];
    }
    
    return likes;
}

// 检测是否已经收藏某作品
+ (bool)checkExist:(int)workId
{
    int count;
    
    NSString *dbPath = [XCZUtils getUserDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT COUNT(*) AS count FROM likes WHERE work_id = %d", workId];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
            count = [s intForColumn:@"count"];
        }
        
        [db close];
    }
    
    return count > 0;
}

// 获取当前最大的showOrder
+ (int)getMaxShowOrder
{
    int maxShowOrder;
    
    NSString *dbPath = [XCZUtils getUserDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT MAX(show_order) AS max_show_order FROM likes"];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
            maxShowOrder = [s intForColumn:@"max_show_order"];
        }
        
        [db close];
    }
    
    return maxShowOrder;
}

// 收藏作品
+ (bool)like:(int)workId
{
    int maxShowOrder = [self getMaxShowOrder];
    bool exist = [self checkExist:workId];
    bool result;
    
    if (!exist) {
        NSString *dbPath = [XCZUtils getUserDatabaseFilePath];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO likes (work_id, show_order) VALUES (%d, %d)", workId, maxShowOrder + 1];
            result = [db executeUpdate:query];
            
            [db close];
        }
    }
    
    return result;
}

// 取消收藏作品
+ (bool)unlike:(int)workId
{
    bool exist = [self checkExist:workId];
    bool result;
    
    if (exist) {
        NSString *dbPath = [XCZUtils getUserDatabaseFilePath];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            NSString *query = [[NSString alloc] initWithFormat:@"DELETE FROM likes WHERE work_id = %d", workId];
            result = [db executeUpdate:query];
            
            [db close];
        }
    }
    
    return result;
}

@end
