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

@property (strong, nonatomic) WorkDetailsView *detailsView;

@end

@implementation MeetViewController

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
    
    self.navigationItem.title = @"偶遇";
    
    UIImage *plusIcon = [IonIcons imageWithIcon:ion_android_refresh size:28 color:[UIColor lightGrayColor]];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:plusIcon style:UIBarButtonItemStylePlain target:self action:@selector(refreshWork)];
    
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
