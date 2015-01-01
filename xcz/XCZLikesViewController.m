//
//  XCZLikesViewController.m
//  xcz
//
//  Created by 刘志鹏 on 15/1/1.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZLikesViewController.h"
#import "XCZWorkDetailViewController.h"
#import "XCZLike.h"
#import "XCZWork.h"

@interface XCZLikesViewController ()

@property (nonatomic, strong) NSMutableArray *works;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XCZLikesViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"我的收藏";
        
        // 加载收藏作品
        [self loadData];
    }
    
    return self;
}

// 加载数据
- (void)loadData
{
    self.works = [[NSMutableArray alloc] init];
    NSMutableArray *likes = [XCZLike getAll];
    
    for (int i = 0; i < likes.count; i++) {
        XCZLike *like = likes[i];
        XCZWork *work = [XCZWork getById:like.workId];
        self.works[i] = work;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchDisplayController.searchBar.placeholder = @"搜索";
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //添加“编辑”按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"编辑"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(toggleEditingMode:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    // 收到数据重载通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotificationReceived:) name:@"reloadLikesData" object:nil];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.tableView.isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
    }
}

// 取消收藏
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DSADSA");
        XCZWork *work = self.works[indexPath.row];
        [XCZLike unlike:work.id];
        [self.works removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // 取消选中效果
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

- (void)reloadNotificationReceived:(NSNotification*) notification
{
    [self loadData];
    [self.tableView reloadData];
}

// 过滤结果
- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullTitle contains[c] %@", searchText];
    NSLog(@"%@", searchText);
    self.searchResults = [self.works filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
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
    
    cell.textLabel.text = work.fullTitle;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"[%@] %@", work.dynasty, work.author];
    return cell;
}

// 选中某单元格后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCZWorkDetailViewController *detailController = [[XCZWorkDetailViewController alloc] init];
    
    XCZWork *work = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        work = self.searchResults[indexPath.row];
    } else {
        work = self.works[indexPath.row];
    }
    
    detailController.work = work;
    [self.navigationController pushViewController:detailController animated:YES];
}

// 以下3个message用于解决键盘位置占据了searchResultsTableView下方空间的bug
// 参见：http://stackoverflow.com/questions/19069503/uisearchdisplaycontrollers-searchresultstableviews-contentsize-is-incorrect-b
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillHide {
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
