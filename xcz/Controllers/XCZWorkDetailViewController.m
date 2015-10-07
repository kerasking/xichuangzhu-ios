//
//  XCZWorkDetailViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-30.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZQuote.h"
#import "XCZLike.h"
#import "XCZLabel.h"
#import "XCZWorkDetailViewController.h"
#import "XCZAuthorDetailsViewController.h"
#import "UILabel+SetFont.h"
#import "XCZUtils.h"
#import "UIColor+Helper.h"
#import <AVOSCloud/AVOSCloud.h>
#import <ionicons/IonIcons.h>
#import <Masonry/Masonry.h>

@interface XCZWorkDetailViewController ()

@end

@implementation XCZWorkDetailViewController

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showAuthorButton = YES;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化navbar按钮
    bool showLike = ![XCZLike checkExist:self.work.id];
    [self initNavbarShowAuthor:self.showAuthorButton showLike:showLike];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleBars:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AVAnalytics beginLogPageView:[[NSString alloc] initWithFormat:@"work-%@/%@", self.work.author, self.work.title]];
    
    // 从其他页面跳转过来时，将navbar标题设置为空
    self.navigationItem.title = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:[[NSString alloc] initWithFormat:@"work-%@/%@", self.work.author, self.work.title]];
}

#pragma mark - Layout

- (void)createViews
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    
    // 标题
    XCZLabel *titleLabel = [XCZLabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.font = [UIFont systemFontOfSize:25];
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    titleParagraphStyle.lineHeightMultiple = 1.2;
    titleParagraphStyle.alignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.work.title attributes:@{NSParagraphStyleAttributeName: titleParagraphStyle}];
    [contentView addSubview:titleLabel];
    
    // 作者
    UILabel *authorLabel = [UILabel new];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.text = [[NSString alloc] initWithFormat:@"[%@] %@", self.work.dynasty, self.work.author];
    [contentView addSubview:authorLabel];
    
    // 内容
    XCZLabel *contentLabel = [XCZLabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    if ([self.work.layout isEqual: @"indent"]) {
        // 缩进排版
        contentParagraphStyle.firstLineHeadIndent = 25;
        contentParagraphStyle.paragraphSpacing = 20;
        contentParagraphStyle.lineHeightMultiple = 1.35;
    } else {
        // 居中排版
        contentParagraphStyle.alignment = NSTextAlignmentCenter;
        contentParagraphStyle.paragraphSpacing = 10;
        contentParagraphStyle.lineHeightMultiple = 1;
    }
    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.work.content attributes:@{NSParagraphStyleAttributeName: contentParagraphStyle}];
    [contentView addSubview:contentLabel];
    
    // 评析header
    UILabel *introHeaderLabel = [UILabel new];
    introHeaderLabel.text = @"评析";
    introHeaderLabel.textColor = [UIColor XCZMainColor];
    [contentView addSubview:introHeaderLabel];
    
    // 评析
    XCZLabel *introLabel = [XCZLabel new];
    introLabel.numberOfLines = 0;
    introLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introLabel.font = [UIFont systemFontOfSize:14];
    introLabel.textColor = [UIColor colorWithRGBA:0x333333FF];
    NSMutableParagraphStyle *introParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    introParagraphStyle.lineHeightMultiple = 1.3;
    introParagraphStyle.paragraphSpacing = 8;
    introLabel.attributedText = [[NSAttributedString alloc] initWithString:self.work.intro attributes:@{NSParagraphStyleAttributeName: introParagraphStyle}];
    [contentView addSubview:introLabel];
    
    // 约束
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(40);
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
    }];
    titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - 20 * 2;
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.work.layout isEqual: @"indent"]) {
            make.top.equalTo(authorLabel.mas_bottom).offset(10);
        } else {
            make.top.equalTo(authorLabel.mas_bottom).offset(16);
        }
        
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
    }];
    contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - 15 * 2;
    
    [introHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(20);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
    }];
    
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introHeaderLabel.mas_bottom).offset(5);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.bottom.equalTo(contentView).offset(-20);
    }];
    introLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - 15 * 2;
    
    CGSize size = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height);
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), size.height);
}

#pragma mark - Public Interface

#pragma mark - User Interface

// 进入/退出全屏模式
- (void)toggleBars:(UITapGestureRecognizer *)gesture
{
    // Toggle statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationSlide];
    
    // Toggle navigationbar
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.hidden animated:YES];
    
    // Toggle tabbar
    [self.view layoutIfNeeded];
    
    BOOL tabBarHidden = self.tabBarController.tabBar.hidden;
    
    // 全屏模式下，扩大title的顶部间距
//    if (tabBarHidden) {
//        self.titleTopConstraint.constant = 40;
//    } else {
//        self.titleTopConstraint.constant = 60;
//    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
    
    [self.tabBarController.tabBar setHidden:!tabBarHidden];
}

- (void)redirectToAuthor:(id)sender
{
    [self.navigationItem setTitle:@"返回"];
    
    XCZAuthorDetailsViewController *authorDetailController = [[XCZAuthorDetailsViewController alloc] initWithAuthorId:self.work.authorId];
    [self.navigationController pushViewController:authorDetailController animated:YES];
}

- (void)likeWork:(id)sender
{
    bool result = [XCZLike like:self.work.id];
    
    if (result) {
        [self initNavbarShowAuthor:self.showAuthorButton showLike:false];
    }
    
    // 发送数据重载通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLikesData" object:nil userInfo:nil];
}

- (void)unlikeWork:(id)sender
{
    bool result = [XCZLike unlike:self.work.id];
    
    if (result) {
        [self initNavbarShowAuthor:self.showAuthorButton showLike:true];
    }
    
    // 发送数据重载通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLikesData" object:nil userInfo:nil];
}

#pragma mark - SomeDelegate

#pragma mark - Internal Helpers

// 设置navbar的按钮显示
- (void)initNavbarShowAuthor:(bool)showAuthor showLike:(bool)showLike
{
    NSMutableArray *btnArrays = [NSMutableArray new];
    
    // 是否显示作者按钮
    if (showAuthor) {
        UIBarButtonItem * authorButton = [self createAuthorButton];
        [btnArrays addObject:authorButton];
    }
    
    // 显示收藏/取消收藏按钮
    if (showLike) {
        UIBarButtonItem * likeButton = [self createLikeButton];
        [btnArrays addObject:likeButton];
    } else {
        UIBarButtonItem * unlikeButton = [self createUnlikeButton];
        [btnArrays addObject:unlikeButton];
    }
    
    self.navigationItem.rightBarButtonItems = btnArrays;
}

// 创建AuthorButton
- (UIBarButtonItem *)createAuthorButton
{
    UIImage *authorIcon = [IonIcons imageWithIcon:ion_ios_person_outline
                                        iconColor:self.view.tintColor
                                         iconSize:31.0f
                                        imageSize:CGSizeMake(31.0f, 31.0f)];
    return [[UIBarButtonItem alloc] initWithImage:authorIcon style:UIBarButtonItemStylePlain target:self action:@selector(redirectToAuthor:)];
}

// 创建LikeButton
- (UIBarButtonItem *)createLikeButton
{
    UIImage *likeIcon = [IonIcons imageWithIcon:ion_ios_star_outline
                                      iconColor:self.view.tintColor
                                       iconSize:27.0f
                                      imageSize:CGSizeMake(27.0f, 27.0f)];
    return [[UIBarButtonItem alloc] initWithImage:likeIcon style:UIBarButtonItemStylePlain target:self action:@selector(likeWork:)];
}

// 创建UnlikeButton
- (UIBarButtonItem *)createUnlikeButton
{
    UIImage *unlikeIcon = [IonIcons imageWithIcon:ion_ios_star
                                        iconColor:self.view.tintColor
                                         iconSize:27.0f
                                        imageSize:CGSizeMake(27.0f, 27.0f)];
    return [[UIBarButtonItem alloc] initWithImage:unlikeIcon style:UIBarButtonItemStylePlain target:self action:@selector(unlikeWork:)];
}

#pragma mark - Getters & Setters

@end
