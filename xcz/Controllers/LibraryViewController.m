//
//  LibraryViewController.m
//  xcz
//
//  Created by hustlzp on 15/10/7.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "LibraryViewController.h"
#import "XCZWorksViewController.h"
#import "XCZAuthorsViewController.h"

@interface LibraryViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) XCZWorksViewController *worksViewController;
@property (strong, nonatomic) XCZAuthorsViewController *authorsViewController;

@end

@implementation LibraryViewController

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
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"作品", @"文学家"]];
    self.segmentControl = segmentControl;
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentControlTapped) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Layout

- (void)createViews
{
    self.worksViewController = [XCZWorksViewController new];
    [self addChildViewController:self.worksViewController];
    [self.view addSubview:self.worksViewController.view];
    self.worksViewController.view.frame = self.view.bounds;

    self.authorsViewController = [XCZAuthorsViewController new];
    [self addChildViewController:self.authorsViewController];
    [self.view addSubview:self.authorsViewController.view];
    self.authorsViewController.view.frame = self.view.bounds;
    self.authorsViewController.view.hidden = YES;
}

#pragma mark - Public Interface

#pragma mark - User Interface

- (void)segmentControlTapped
{
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.authorsViewController.view.hidden = YES;
        self.worksViewController.view.hidden = NO;
    } else {
        self.authorsViewController.view.hidden = NO;
        self.worksViewController.view.hidden = YES;
    }
}

#pragma mark - SomeDelegate

#pragma mark - Internal Helpers

#pragma mark - Getters & Setters


@end
