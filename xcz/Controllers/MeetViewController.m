//
//  MeetViewController.m
//  xcz
//
//  Created by hustlzp on 15/10/7.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZWork.h"
#import "WorkDetailsView.h"
#import "MeetViewController.h"
#import <ionicons/IonIcons.h>
#import <Masonry/Masonry.h>

@interface MeetViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) WorkDetailsView *detailsView;

@end

@implementation MeetViewController

#pragma mark - LifeCycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleBars:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self createViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"偶遇";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *refreshIcon = [IonIcons imageWithIcon:ion_ios_loop_strong size:24 color:[UIColor lightGrayColor]];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:refreshIcon style:UIBarButtonItemStylePlain target:self action:@selector(refreshWork)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Layout

- (void)createViews
{
    WorkDetailsView *detailsView = [[WorkDetailsView alloc] initWithWork:[XCZWork getRandomWork] width:CGRectGetWidth(self.view.frame)];
    self.detailsView = detailsView;
    [self.view addSubview:detailsView];
    [detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    if (tabBarHidden) {
        [self.detailsView exitFullScreenMode];
    } else {
        [self.detailsView enterFullScreenMode];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
    
    [self.tabBarController.tabBar setHidden:!tabBarHidden];
}

#pragma mark - SomeDelegate

#pragma mark - Internal Helpers

- (void)refreshWork
{
    [self.detailsView removeFromSuperview];
    
    WorkDetailsView *detailsView = [[WorkDetailsView alloc] initWithWork:[XCZWork getRandomWork] width:CGRectGetWidth(self.view.frame)];
    self.detailsView = detailsView;
    [self.view addSubview:detailsView];
    
    [detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Getters & Setters


@end
