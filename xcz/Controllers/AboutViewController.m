//
//  AboutViewController.m
//  xcz
//
//  Created by hustlzp on 15/10/8.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZWork.h"
#import "AboutViewController.h"
#import "XCZWorkDetailViewController.h"
#import "UIColor+Helper.h"
#import <Masonry/Masonry.h>

@interface AboutViewController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AboutViewController

#pragma mark - LifeCycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // wap
    UIView *wapView = [UIView new];
    
    // logo
    UIImageView *logoView = [UIImageView new];
    logoView.image = [UIImage imageNamed:@"AppIcon40x40"];
    logoView.layer.cornerRadius = 3;
    logoView.layer.masksToBounds = YES;
    [wapView addSubview:logoView];
    
    // text
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"西窗烛";
        textLabel.font = [UIFont systemFontOfSize:17];
    [wapView addSubview:textLabel];
    
    // 约束
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(wapView);
        make.width.height.equalTo(@20);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logoView);
        make.left.equalTo(logoView.mas_right).offset(5);
        make.right.equalTo(wapView);
    }];
    
    CGSize size = [wapView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    wapView.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.navigationItem.titleView = wapView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Layout

- (void)createViews
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];

    UIView *contentView = [self createContentView];
    [scrollView addSubview:contentView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.edges.equalTo(scrollView);
    }];
}

- (UIView *)createContentView
{
    UIView *contentView = [UIView new];
    
    // slogan wap
    UIView *sloganWapView = [UIView new];
    sloganWapView.backgroundColor = [UIColor colorWithRGBA:0xF2F2F2FF];
    UITapGestureRecognizer *gestureForSlogan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sloganTapped:)];
    [sloganWapView addGestureRecognizer:gestureForSlogan];
    [contentView addSubview:sloganWapView];
    
    // slogan
    UILabel *sloganLabel = [UILabel new];
    sloganLabel.numberOfLines = 0;
    sloganLabel.lineBreakMode = NSLineBreakByWordWrapping;
    sloganLabel.font = [UIFont systemFontOfSize:20];
    NSString *sloganText = @"何当共剪西窗烛，\n却话巴山夜雨时。";
    NSMutableAttributedString *attributedStringForSlogan = [[NSMutableAttributedString alloc] initWithString:sloganText];
    NSMutableParagraphStyle *paragraphStyleForSlogan = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleForSlogan.alignment = NSTextAlignmentCenter;
    paragraphStyleForSlogan.lineSpacing = 10;
    [attributedStringForSlogan addAttribute:NSParagraphStyleAttributeName value:paragraphStyleForSlogan range:NSMakeRange(0, sloganText.length)];
    sloganLabel.attributedText = attributedStringForSlogan;
    [sloganWapView addSubview:sloganLabel];
    
    // slogan from
    UILabel *sloganFromLabel = [UILabel new];
    sloganFromLabel.text = @"— [唐] 李商隐";
    sloganFromLabel.textColor = [UIColor colorWithRGBA:0x333333FF];
    sloganFromLabel.font = [UIFont systemFontOfSize:12];
    [sloganWapView addSubview:sloganFromLabel];
    
    // about
    UILabel *aboutLabel = [UILabel new];
    aboutLabel.numberOfLines = 0;
    aboutLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aboutLabel.font = [UIFont systemFontOfSize:15];
    NSString *aboutText = @"西窗烛旨在为大家提供一个干净的古典文学欣赏空间。大江东去的豪放明快、低头弄青梅的婉媚曲折、西窗剪烛的情深意重，每次读到都会有所触动。文学之美，与时代无关。";
    NSMutableAttributedString *attributedStringForAbout = [[NSMutableAttributedString alloc] initWithString:aboutText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [attributedStringForAbout addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, aboutText.length)];
    aboutLabel.attributedText = attributedStringForAbout;
    [contentView addSubview:aboutLabel];
    
    // contact
    UILabel *contactLabel = [UILabel new];
    contactLabel.numberOfLines = 0;
    contactLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contactLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *contactPreString = [[NSMutableAttributedString alloc] initWithString:@"任何建议请联系：\n" attributes:@{}];
    NSMutableAttributedString *contactProString = [[NSMutableAttributedString alloc] initWithString:@"hi@xichuangzhu.com" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [contactPreString appendAttributedString:contactProString];
    
    NSMutableParagraphStyle *paragraphStyleForContact = [NSMutableParagraphStyle new];
    paragraphStyleForContact.lineSpacing = 2;
    [contactPreString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleForContact range:NSMakeRange(0, contactPreString.length)];
    
    contactLabel.attributedText = contactPreString;
    contactLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureForContact = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactTapped)];
    [contactLabel addGestureRecognizer:gestureForContact];
    [contentView addSubview:contactLabel];
    
    // website
    UILabel *websiteLabel = [UILabel new];
    websiteLabel.numberOfLines = 0;
    websiteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    websiteLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *websitePreString = [[NSMutableAttributedString alloc] initWithString:@"西窗烛网页版：\n" attributes:@{}];
    NSMutableAttributedString *websiteProString = [[NSMutableAttributedString alloc] initWithString:@"http://www.xichuangzhu.com" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [websitePreString appendAttributedString:websiteProString];
    
    NSMutableParagraphStyle *paragraphStyleForWebsite = [NSMutableParagraphStyle new];
    paragraphStyleForWebsite.lineSpacing = 2;
    [websitePreString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleForWebsite range:NSMakeRange(0, websitePreString.length)];
    
    websiteLabel.attributedText = websitePreString;
    websiteLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureForWebsite = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteTapped)];
    [websiteLabel addGestureRecognizer:gestureForWebsite];
    [contentView addSubview:websiteLabel];
    
    // 约束
    
    [sloganWapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
    }];
    
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sloganWapView);
        make.top.equalTo(sloganWapView).offset(40);
    }];
    
    [sloganFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sloganWapView).offset(-30);
        make.top.equalTo(sloganLabel.mas_bottom).offset(20);
        make.bottom.equalTo(sloganWapView).offset(-15);
    }];
    
    [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sloganWapView.mas_bottom).offset(30);
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutLabel.mas_bottom).offset(20);
        make.left.right.equalTo(aboutLabel);
    }];
    
    [websiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactLabel.mas_bottom).offset(20);
        make.left.right.equalTo(contactLabel);
        make.bottom.equalTo(contentView).offset(-60);
    }];

    return contentView;
}

#pragma mark - Public Interface

#pragma mark - User Interface

- (void)contactTapped
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:hi@xichuangzhu.com"]];
}

- (void)websiteTapped
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xichuangzhu.com"]];
}

- (void)sloganTapped:(UITapGestureRecognizer *)gesture
{
    gesture.view.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        gesture.view.backgroundColor = [UIColor colorWithRGBA:0xF2F2F2FF];
    });
    
    XCZWorkDetailViewController *detailController = [[XCZWorkDetailViewController alloc] init];
    detailController.work = [XCZWork getById:10024];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - SomeDelegate


#pragma mark - Internal Helpers


#pragma mark - Getters & Setters


@end
