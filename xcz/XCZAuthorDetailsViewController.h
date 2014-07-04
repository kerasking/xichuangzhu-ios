//
//  XCZAuthorDetailsViewController.h
//  xcz
//
//  Created by 刘志鹏 on 14-7-4.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCZAuthor.h"

@interface XCZAuthorDetailsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *works;
@property (nonatomic, strong) XCZAuthor *author;

@end
