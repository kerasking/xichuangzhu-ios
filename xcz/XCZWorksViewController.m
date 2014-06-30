//
//  XCZWorksViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-28.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWorksViewController.h"
#import "XCZWorkDetailViewController.h"
#import <FMDB/FMDB.h>

@interface XCZWorksViewController ()

@end

@implementation XCZWorksViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"西窗烛";
    
    int index = 0;
    self.works = [[NSMutableArray alloc] init];
    
    // 从SQLite中加载数据
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM works"];
        while ([s next]) {
            XCZWork *work = [[XCZWork alloc] init];
            work.id = [s intForColumn:@"id"];
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

// 表行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.works count];
}

// 单元格内容
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

// 选中某单元格后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZWorkDetailViewController *detailController = [[XCZWorkDetailViewController alloc] init];
    XCZWork *work = self.works[indexPath.row];
    detailController.work = work;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
