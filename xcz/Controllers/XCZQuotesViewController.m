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
#import <AVOSCloud/AVOSCloud.h>

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
        navItem.title = @"摘录";
        
        // 根据屏幕大小来确定摘录的显示数目，以保证一屏能够显示完全
        int height = (int)([[UIScreen mainScreen] bounds].size.height);
        switch (height) {
            case 480:
                self.quotesCount = 8;
                break;
                
            case 568:
                self.quotesCount = 10;
                break;
                
            case 667:
                self.quotesCount = 12;
                break;
                
            case 736:
                self.quotesCount = 14;
                break;
                
            default:
                self.quotesCount = 10;
                break;
        }
        
        // 加载摘录
        [self loadQuotes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加“换一换”按钮
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
    self.quotes = [XCZQuote getRandomQuotes:self.quotesCount];
}

- (IBAction)refreshQuotes:(id)sender {
    [AVAnalytics event:@"refresh_random_works"]; // “换一换”事件。
    [self loadQuotes];
    
    [UIView transitionWithView: self.tableView
                      duration: 0.2f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
     }];
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
    XCZWork *work = [XCZWork getById:quote.workId];
    detailController.work = work;

    [self.navigationController pushViewController:detailController animated:YES];
}

// 用于支持tableviewcell文字赋值
-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    XCZQuote *quote = self.quotes[indexPath.row];
    pasteboard.string = quote.quote;
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)tableView:(UITableView*)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

@end
