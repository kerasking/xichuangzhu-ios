//
//  XCZWorksViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-28.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWorksViewController.h"
#import <FMDB/FMDB.h>

@interface XCZWorksViewController ()

@end

@implementation XCZWorksViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    int index = 0;
    self.works = [[NSMutableArray alloc] init];
    
    // 从SQLite中加载数据
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM works"];
        while ([s next]) {
            XCZWork *work = [[XCZWork alloc] init];
            work.title = [s stringForColumn:@"title"];
            work.author = [s stringForColumn:@"author"];
            work.dynasty = [s stringForColumn:@"dynasty"];
            work.kind = [s stringForColumn:@"kind"];
            work.foreword = [s stringForColumn:@"foreword"];
            work.content = [s stringForColumn:@"content"];
            work.intro = [s stringForColumn:@"intro"];
            work.layout = [s stringForColumn:@"layout"];
            self.works[index] = work;
            index++;
        }
        
        [db close];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.works count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    XCZWork *work = self.works[indexPath.row];
    cell.textLabel.text = work.title;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"[%@] %@", work.dynasty, work.author];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
