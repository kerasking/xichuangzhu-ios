//
//  XCZAuthor.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZAuthor.h"
#import "XCZUtils.h"
#import <FMDB/FMDB.h>

@implementation XCZAuthor

// 根据id获取文学家
+ (XCZAuthor *)getById:(int)authorId
{
    XCZAuthor *author = [[XCZAuthor alloc] init];
    
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM authors WHERE id = %d", authorId];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
            [author loadFromResultSet:s];
        }
        
        [db close];
    }
    
    return author;
}

// 获取某文学家的作品总数
+ (int)getWorksCount:(int)authorId
{
    int worksCount = 0;
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
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

// 获取某朝代的所有文学家
+ (NSMutableArray *)getAuthorsByDynasty:(NSString *)dynasty
{
    int index = 0;
    NSMutableArray *authors = [[NSMutableArray alloc] init];
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM authors WHERE dynasty = '%@' ORDER BY birth_year ASC", dynasty];
        
        FMResultSet *s = [db executeQuery:query];

        while ([s next]) {
            XCZAuthor *author = [[XCZAuthor alloc] init];
            [author loadFromResultSet:s];
            authors[index] = author;
            index++;
        }
        
        [db close];
    }
    
    return authors;
}

// 获取所有文学家
+ (NSMutableArray *)getAllAuthors
{
    int index = 0;
    NSMutableArray *authors = [[NSMutableArray alloc] init];
    NSString *dbPath = [XCZUtils getDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM authors"];
        while ([s next]) {
            XCZAuthor *author = [[XCZAuthor alloc] init];
            [author loadFromResultSet:s];
            authors[index] = author;
            index++;
        }

        [db close];
    }
    
    return authors;
}

- (void)loadFromResultSet:(FMResultSet *)resultSet
{
    self.id = [resultSet intForColumn:@"id"];
    self.name = [resultSet stringForColumn:@"name"];
    self.intro = [resultSet stringForColumn:@"intro"];
    self.dynasty = [resultSet stringForColumn:@"dynasty"];
    self.birthYear = [resultSet stringForColumn:@"birth_year"];
    self.deathYear = [resultSet stringForColumn:@"death_year"];
}

@end
