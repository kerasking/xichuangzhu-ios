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

@property (nonatomic, strong) NSMutableArray *dynasties;
@property (nonatomic, strong) NSMutableDictionary *authors;

@end

@implementation XCZAuthorsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"文学家";
        
        int index = 0;
        int _index = 0;
        
        self.dynasties = [[NSMutableArray alloc] init];
        self.authors = [[NSMutableDictionary alloc] init];
        
        // 从SQLite中加载数据
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
        NSLog(@"%@", dbPath);
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            index = 0;
            FMResultSet *s = [db executeQuery:@"SELECT * FROM dynasties ORDER BY start_year ASC"];
            while ([s next]) {
                NSString* dynastyName = [s stringForColumn:@"name"];
                // 填充dynasties数组
                self.dynasties[index] = dynastyName;
                
                // 填充authors字典
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
            
            [db close];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dynasties.count;
}

// 每个Section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *dynastyName = [self.dynasties objectAtIndex:section];
    NSArray *authors = [self.authors objectForKey:dynastyName];
    return authors.count;
}

// Section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dynasties[section];
}

// 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
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

// 单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *dynastyName = [self.dynasties objectAtIndex:indexPath.section];
    NSArray *authors = [self.authors objectForKey:dynastyName];
    XCZAuthor *author = authors[indexPath.row];

    cell.textLabel.text = author.name;
    return cell;
}

// 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZAuthorDetailsViewController *detailController = [[XCZAuthorDetailsViewController alloc] init];
    
    NSString *dynastyName = [self.dynasties objectAtIndex:indexPath.section];
    NSArray *authors = [self.authors objectForKey:dynastyName];
    XCZAuthor *author = authors[indexPath.row];

    detailController.author = author;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSMutableArray *works = [[NSMutableArray alloc] init];
    int index = 0;
    
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM works WHERE author_id = %d", author.id];
        FMResultSet *s = [db executeQuery:query];
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
            works[index] = work;
            index++;
        }
        
        [db close];
    }
    detailController.works = works;
    
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
