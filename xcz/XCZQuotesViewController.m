//
//  XCZQuotesViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-5.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZQuotesViewController.h"
#import <FMDB/FMDB.h>
#import "XCZQuote.h"
#import "XCZWorkDetailViewController.h"

@interface XCZQuotesViewController ()

@property (nonatomic) int quotesCount;
@property (nonatomic, strong) NSMutableArray *quotes;
- (void)loadQuotes;

@end

@implementation XCZQuotesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"名言";
        
        // 根据屏幕大小来确定名言的显示数目，以保证一屏能够显示完全
        int height = (int)([[UIScreen mainScreen] bounds].size.height);
        if (height >= 568) {
            self.quotesCount = 10;
        } else {
            self.quotesCount = 8;
        }
        
        // 加载名言
        [self loadQuotes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"换一换"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(refreshQuotes:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

// 随机加载10条名言
- (void)loadQuotes
{
    int index = 0;
    self.quotes = [[NSMutableArray alloc] init];
    
    // 从SQLite中加载数据
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM quotes ORDER BY RANDOM() LIMIT %d", self.quotesCount];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            XCZQuote *quote = [[XCZQuote alloc] init];
            quote.id = [s intForColumn:@"id"];
            quote.quote = [s stringForColumn:@"quote"];
            quote.authorId = [s intForColumn:@"author_id"];
            quote.author = [s stringForColumn:@"author"];
            quote.workId = [s intForColumn:@"work_id"];
            quote.work = [s stringForColumn:@"work"];
            self.quotes[index] = quote;
            index++;
        }
        
        [db close];
    }
}

- (IBAction)refreshQuotes:(id)sender {
    [self loadQuotes];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.quotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    XCZQuote *quote = self.quotes[indexPath.row];
    cell.textLabel.text = quote.quote;
    return cell;
}

// 选中某单元格后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZWorkDetailViewController *detailController = [[XCZWorkDetailViewController alloc] init];
    XCZQuote *quote = self.quotes[indexPath.row];
    
    // 查询work
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    XCZWork *work = [[XCZWork alloc] init];
    
    if ([db open]) {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM works WHERE id = %d", quote.workId];
        FMResultSet *s = [db executeQuery:query];
        if ([s next]) {
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
        }
        
        [db close];
    }
    
    detailController.work = work;

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
