//
//  XCZWorkDetailViewController.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-30.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZWorkDetailViewController.h"

@interface XCZWorkDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property (weak, nonatomic) IBOutlet UILabel *authorField;
@property (weak, nonatomic) IBOutlet UILabel *contentField;
@property (weak, nonatomic) IBOutlet UILabel *introField;

@end

@implementation XCZWorkDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    XCZWork *work = self.work;
    self.titleField.text = work.title;
    self.authorField.text = [[NSString alloc] initWithFormat:@"[%@] %@", work.dynasty, work.author];
    
    self.contentField.text = work.content;
    self.contentField.numberOfLines = 0;
    [self.contentField sizeToFit];
    
    self.introField.text = work.intro;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
