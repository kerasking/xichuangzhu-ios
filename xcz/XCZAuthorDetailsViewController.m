//
//  XCZAuthorDetailsViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-7-4.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZAuthorDetailsViewController.h"
#import <FMDB/FMDB.h>
#import "XCZWork.h"
#import "XCZAuthor.h"
#import "XCZWorkDetailViewController.h"
#import "XCZUtils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface XCZAuthorDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *worksHeaderField;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *periodField;
@property (weak, nonatomic) IBOutlet UILabel *introField;

@property (nonatomic, strong) NSMutableDictionary *works;
@property (nonatomic) int worksCount;
@property (nonatomic, strong) XCZAuthor *author;

@end

@implementation XCZAuthorDetailsViewController

-(instancetype)initWithAuthorId:(int)authorId
{
    self = [super init];
    
    if (self) {
        self.author = [XCZAuthor getById:authorId];
        
        // 加载worksCount
        self.worksCount = [XCZAuthor getWorksCount:authorId];
        
        // 加载works
        self.works = [[NSMutableDictionary alloc] init];
        [self loadWorksByKind:@"文"];
        [self loadWorksByKind:@"诗"];
        [self loadWorksByKind:@"词"];
        [self loadWorksByKind:@"曲"];
        [self loadWorksByKind:@"赋"];
    }
    
    return self;
}

// 根据类别加载作品
- (void)loadWorksByKind:(NSString *)kindCN
{
    NSMutableArray *works = [XCZWork getWorksByAuthorId:self.author.id kind:kindCN];
    
    if ([works count] > 0) {
        [self.works setObject:works forKey:kindCN];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AVAnalytics beginLogPageView:[[NSString alloc] initWithFormat:@"author-%@", self.author.name ]];
    
    // 姓名
    self.nameField.text = self.author.name;
    
    // 时期
    if (![self.author.deathYear isEqualToString:@""]) {
        self.periodField.text = [[NSString alloc] initWithFormat:@"[%@]  %@ ~ %@", self.author.dynasty, self.author.birthYear, self.author.deathYear];
    } else {
        self.periodField.text = [[NSString alloc] initWithFormat:@"[%@]", self.author.dynasty];
    }

    // 简介
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    contentParagraphStyle.lineHeightMultiple = 1.3;
    self.introField.attributedText = [[NSAttributedString alloc] initWithString:self.author.intro attributes:@{NSParagraphStyleAttributeName: contentParagraphStyle}];
    self.introField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 35;
    
    // 作品数目
    self.worksHeaderField.text = [[NSString alloc] initWithFormat:@"作品 / %d", self.worksCount];
    //self.worksHeaderField.text = @"作品";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:[[NSString alloc] initWithFormat:@"author-%@", self.author.name ]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.author.name;
    UIView *headerView = self.headerView;
    [self.tableView setTableHeaderView:headerView];
    
    // 计算introLabel的高度
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        contentParagraphStyle.lineHeightMultiple = 1.3;
    CGRect introSize = [self.author.intro
                        boundingRectWithSize:CGSizeMake([XCZUtils currentWindowWidth] - 35, CGFLOAT_MAX)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName: self.introField.font, NSParagraphStyleAttributeName: contentParagraphStyle}
                        context:nil];
    CGFloat introHeight = introSize.size.height;
    
    CGFloat height = self.introField.frame.origin.y + introHeight;
    height += 15;   // “作品”与简介之间的垂直距离
    height += self.worksHeaderField.frame.size.height;
    height += 12;
    
    // 设置header view的实际高度
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height = height;
    headerView.frame = headerFrame;

    [self.tableView setTableHeaderView:headerView];
}

- (UIView *)headerView
{
    if(!_headerView){
        [[NSBundle mainBundle] loadNibNamed:@"AuthorHeaderView" owner:self options:nil];
    }
    
    return _headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.works.count;
}

// 每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *keys = [self.works allKeys];
    NSString* key = [keys objectAtIndex:section];
    NSArray *works = [self.works objectForKey:key];
    return works.count;
}

// 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSArray *keys = [self.works allKeys];
    NSString* key = [keys objectAtIndex:indexPath.section];
    NSArray *works = [self.works objectForKey:key];
    XCZWork *work = works[indexPath.row];

    cell.textLabel.text = work.title;
    return cell;
}

// Section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *keys = [self.works allKeys];
    NSString *key = [keys objectAtIndex:section];
    return key;
}

// 选中某单元格后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZWorkDetailViewController *detailController = [[XCZWorkDetailViewController alloc] init];
    
    NSArray *keys = [self.works allKeys];
    NSString* key = [keys objectAtIndex:indexPath.section];
    NSArray *works = [self.works objectForKey:key];
    XCZWork *work = works[indexPath.row];
    
    detailController.work = work;
    detailController.showAuthorButton = NO;
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
