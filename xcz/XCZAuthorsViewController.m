//
//  XCZAuthorsViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-3.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZAuthorsViewController.h"
#import <FMDB/FMDB.h>
#import "XCZAuthorDetailsViewController.h"
#import "XCZAuthor.h"
#import "XCZWork.h"

@interface XCZAuthorsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

// 正常显示
@property (nonatomic, strong) NSMutableArray *dynasties;
@property (nonatomic, strong) NSMutableDictionary *authors;

// 用于搜索
@property (nonatomic, strong) NSMutableArray *authorsForSearch;
@property (nonatomic, strong) NSArray *searchResult;


@end

@implementation XCZAuthorsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"文学家";
        
        int index = 0;
        int _index = 0;
        
        self.dynasties = [[NSMutableArray alloc] init];
        self.authors = [[NSMutableDictionary alloc] init];
        self.authorsForSearch = [[NSMutableArray alloc] init];
        
        // 从SQLite中加载数据
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            // 填充dynasties与authors
            index = 0;
            FMResultSet *s = [db executeQuery:@"SELECT * FROM dynasties ORDER BY start_year ASC"];
            while ([s next]) {
                NSString* dynastyName = [s stringForColumn:@"name"];
                // 填充dynasties
                self.dynasties[index] = dynastyName;
                
                // 填充authors
                NSMutableArray *authors = [[NSMutableArray alloc] init];
                NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM authors WHERE dynasty = '%@'", dynastyName];
                FMResultSet *_s = [db executeQuery:query];
                _index = 0;
                while ([_s next]) {
                    XCZAuthor *author = [[XCZAuthor alloc] init];
                    author.id = [_s intForColumn:@"id"];
                    author.name = [_s stringForColumn:@"name"];
                    author.intro = [_s stringForColumn:@"intro"];
                    author.dynasty = [_s stringForColumn:@"dynasty"];
                    author.birthYear = [_s stringForColumn:@"birth_year"];
                    author.deathYear = [_s stringForColumn:@"death_year"];
                    authors[_index] = author;
                    _index++;
                }
                [self.authors setObject:authors forKey:dynastyName];
                index++;
            }
            
            // 填充authorsForSearch
            index = 0;
            s = [db executeQuery:@"SELECT * FROM authors"];
            while ([s next]) {
                XCZAuthor *author = [[XCZAuthor alloc] init];
                author.id = [s intForColumn:@"id"];
                author.name = [s stringForColumn:@"name"];
                author.intro = [s stringForColumn:@"intro"];
                author.dynasty = [s stringForColumn:@"dynasty"];
                author.birthYear = [s stringForColumn:@"birth_year"];
                author.deathYear = [s stringForColumn:@"death_year"];
                self.authorsForSearch[index] = author;
                index++;
            }
            
            [db close];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.searchBar.placeholder = @"搜索";
}

// 以下代码用于修复SearchBar的位置问题
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString *searchText = self.searchDisplayController.searchBar.text;
    if([searchText isEqualToString:@""]) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.topConstraint.constant = 64;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.topConstraint.constant = 20;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.topConstraint.constant = 64;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 过滤结果
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.searchResult = [self.authorsForSearch filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

#pragma mark - Table view data source

// Section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return self.dynasties.count;
    }
}

// 每个Section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResult.count;
    } else {
        NSString *dynastyName = [self.dynasties objectAtIndex:section];
        NSArray *authors = [self.authors objectForKey:dynastyName];
        return authors.count;
    }
}

// Section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    } else {
        return self.dynasties[section];
    }
}

// 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @[];
    } else {
        NSMutableArray *dynasties = [self.dynasties mutableCopy];
        for (int i = 0; i < dynasties.count; i++) {
            if ([dynasties[i] isEqualToString:@"五代十国"]) {
                dynasties[i] = @"五代";
            } else if ([dynasties[i] isEqualToString:@"南北朝"]) {
                dynasties[i] = @"南北";
            }
        }
        
        return dynasties;
    }
}

// 单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    XCZAuthor *author = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        author = self.searchResult[indexPath.row];
    } else {
        NSString *dynastyName = [self.dynasties objectAtIndex:indexPath.section];
        NSArray *authors = [self.authors objectForKey:dynastyName];
        author = authors[indexPath.row];
    }

    cell.textLabel.text = author.name;
    return cell;
}

// 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZAuthor *author = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        author = self.searchResult[indexPath.row];
    } else {
        NSString *dynastyName = [self.dynasties objectAtIndex:indexPath.section];
        NSArray *authors = [self.authors objectForKey:dynastyName];
        author = authors[indexPath.row];
    }
    
    XCZAuthorDetailsViewController *detailController = [[XCZAuthorDetailsViewController alloc] initWithAuthorId:author.id];

    [self.navigationController pushViewController:detailController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
