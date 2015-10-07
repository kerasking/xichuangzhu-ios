//
//  WorkDetailsView.m
//  xcz
//
//  Created by hustlzp on 15/10/7.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "WorkDetailsView.h"
#import "UIColor+Helper.h"
#import <Masonry/Masonry.h>

@interface WorkDetailsView ()

@property (strong, nonatomic) XCZWork *work;
@property (nonatomic) CGFloat width;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *introLabel;

@end

@implementation WorkDetailsView

- (instancetype)initWithWork:(XCZWork *)work width:(CGFloat)width
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.work = work;
    self.width = width;
    
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    
    // 标题
    UILabel *titleLabel = [UILabel new];
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
    UILabel *contentLabel = [UILabel new];
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
    UILabel *introLabel = [UILabel new];
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
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(40);
        make.left.equalTo(contentView).offset(20);
        make.right.equalTo(contentView).offset(-20);
    }];
    titleLabel.preferredMaxLayoutWidth = width - 20 * 2;
    
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
    contentLabel.preferredMaxLayoutWidth = width - 15 * 2;
    
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
    introLabel.preferredMaxLayoutWidth = width - 15 * 2;
    
    CGSize size = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    contentView.frame = CGRectMake(0, 0, width, size.height);
    self.contentSize = CGSizeMake(width, size.height);
    
    return self;
}

- (void)updateWithWork:(XCZWork *)work
{
}

@end
