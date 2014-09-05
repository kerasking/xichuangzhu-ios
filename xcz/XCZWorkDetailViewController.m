//
//  XCZWorkDetailViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-30.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWorkDetailViewController.h"
#import "XCZUtils.h"
#import "XCZAuthorDetailsViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface XCZWorkDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property (weak, nonatomic) IBOutlet UILabel *authorField;
@property (weak, nonatomic) IBOutlet UILabel *contentField;
@property (weak, nonatomic) IBOutlet UILabel *introField;

@end

@implementation XCZWorkDetailViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.showAuthorButton = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AVAnalytics beginLogPageView:[[NSString alloc] initWithFormat:@"work-%@/%@", self.work.author, self.work.title]];
    
    // 从其他页面跳转过来时，将navbar标题设置为空
    self.navigationItem.title = @"";
    
    XCZWork *work = self.work;
    
    // 标题
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    titleParagraphStyle.lineHeightMultiple = 1.2;
    titleParagraphStyle.alignment = NSTextAlignmentCenter;
    self.titleField.attributedText = [[NSAttributedString alloc] initWithString:work.title attributes:@{NSParagraphStyleAttributeName: titleParagraphStyle}];
    
    // 作者
    self.authorField.text = [[NSString alloc] initWithFormat:@"[%@] %@", work.dynasty, work.author];
    
    // 内容
    NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 缩进排版
    if ([self.work.layout isEqual: @"indent"]) {
        contentParagraphStyle.firstLineHeadIndent = 25;
        contentParagraphStyle.paragraphSpacing = 20;
        contentParagraphStyle.lineHeightMultiple = 1.35;
        self.contentField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 30;
    // 居中排版
    } else {
        contentParagraphStyle.alignment = NSTextAlignmentCenter;
        contentParagraphStyle.paragraphSpacing = 0;
        contentParagraphStyle.lineHeightMultiple = 1;
        self.authorTopConstraint.constant = 16;
        self.contentField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 20;
    }
    contentParagraphStyle.paragraphSpacing = 10;
    self.contentField.attributedText = [[NSAttributedString alloc] initWithString:work.content attributes:@{NSParagraphStyleAttributeName: contentParagraphStyle}];
    
    // 评析
    NSMutableParagraphStyle *introParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    introParagraphStyle.lineHeightMultiple = 1.3;
    introParagraphStyle.paragraphSpacing = 10;
    self.introField.attributedText = [[NSAttributedString alloc] initWithString:work.intro attributes:@{NSParagraphStyleAttributeName: introParagraphStyle}];
    
    // 设置UILabel的preferredMaxLayoutWidth，以保证正确的换行长度
    self.titleField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 50;
    self.introField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 30;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:[[NSString alloc] initWithFormat:@"work-%@/%@", self.work.author, self.work.title]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.showAuthorButton) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                        initWithTitle:self.work.author
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(redirectToAuthor:)];
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
}

- (IBAction)redirectToAuthor:(id)sender
{
    [self.navigationItem setTitle:@"返回"];
    
    XCZAuthorDetailsViewController *authorDetailController = [[XCZAuthorDetailsViewController alloc] initWithAuthorId:self.work.authorId];
    [self.navigationController pushViewController:authorDetailController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
