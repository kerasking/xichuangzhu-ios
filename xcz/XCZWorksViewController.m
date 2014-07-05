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
#import "XCZWork.h"

@interface XCZWorksViewController ()

@property (nonatomic, strong) NSMutableArray *works;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation XCZWorksViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"全部作品";
        
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
                work.authorId = [s intForColumn:@"author_id"];
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
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

// 过滤结果
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    self.searchResults = [self.works filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

// 以下代码用于修复SearchBar的位置问题
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString *searchText = self.searchDisplayController.searchBar.text;
    if([searchText isEqualToString:@""]){
        self.topConstraint.constant = 64;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.topConstraint.constant = 20;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.topConstraint.constant = 64;
}

// 表行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.works count];
    }
}

// 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    XCZWork *work = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        work = self.searchResults[indexPath.row];
    } else {
        work = self.works[indexPath.row];
    }
    
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
