//
//  XCZWorkDetailViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-30.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWorkDetailViewController.h"
#import "XCZUtils.h"
#import "XCZQuote.h"
#import "IonIcons.h"
#import "XCZLike.h"
#import "XCZAuthorDetailsViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface XCZWorkDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
     initWithTitle:self.work.author
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(redirectToAuthor:)];*/
    //[self.navigationItem setRightBarButtonItem:rightButton];
    
    UIImage *authorIcon = [IonIcons imageWithIcon:icon_ios7_person_outline
                                        iconColor:self.view.tintColor
                                         iconSize:30.0f
                                        imageSize:CGSizeMake(30.0f, 30.0f)];
    UIBarButtonItem *authorButton = [[UIBarButtonItem alloc] initWithImage:authorIcon style:UIBarButtonItemStylePlain target:self action:@selector(redirectToAuthor:)];
    
    UIImage *likeIcon = [IonIcons imageWithIcon:icon_ios7_heart_outline
                                      iconColor:self.view.tintColor
                                       iconSize:30.0f
                                      imageSize:CGSizeMake(30.0f, 30.0f)];
    UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithImage:likeIcon style:UIBarButtonItemStylePlain target:self action:@selector(likeWork:)];
    
    // 是否显示作者按钮
    if (self.showAuthorButton) {
        self.navigationItem.rightBarButtonItems = @[authorButton, likeButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[likeButton];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleBars:)];
    [self.view addGestureRecognizer:singleTap];
}

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
    if (tabBarHidden) {
        self.titleTopConstraint.constant = 40;
    } else {
        self.titleTopConstraint.constant = 60;
    }
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
    [self.tabBarController.tabBar setHidden:!tabBarHidden];
}

// 移除NSNotification Observer
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 发起本地通知
    /*
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
    [components setHour:12];
    [components setMinute:48];

    XCZQuote *quote = [XCZQuote getRandomQuote];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.fireDate = [calendar dateFromComponents:components];
    
    [localNotification setRepeatInterval: NSMinuteCalendarUnit];
    
    localNotification.alertBody = [[NSString alloc] initWithFormat:@"每日一句：%@—《%@》", quote.quote, quote.work];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:quote.workId] forKey:@"workId"];
    localNotification.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    */
     
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
    introParagraphStyle.paragraphSpacing = 8;
    self.introField.attributedText = [[NSAttributedString alloc] initWithString:work.intro attributes:@{NSParagraphStyleAttributeName: introParagraphStyle}];
    
    // 设置UILabel的preferredMaxLayoutWidth，以保证正确的换行长度
    self.titleField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 50;
    self.introField.preferredMaxLayoutWidth = [XCZUtils currentWindowWidth] - 30;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AVAnalytics endLogPageView:[[NSString alloc] initWithFormat:@"work-%@/%@", self.work.author, self.work.title]];
}

- (IBAction)redirectToAuthor:(id)sender
{
    [self.navigationItem setTitle:@"返回"];
    
    XCZAuthorDetailsViewController *authorDetailController = [[XCZAuthorDetailsViewController alloc] initWithAuthorId:self.work.authorId];
    [self.navigationController pushViewController:authorDetailController animated:YES];
}

- (IBAction)likeWork:(id)sender
{
    [XCZLike like:self.work.id];
    
    // 发送数据重载通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLikesData" object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
