//
//  WorkDetailsView.h
//  xcz
//
//  Created by hustlzp on 15/10/7.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZWork.h"
#import <UIKit/UIKit.h>

@interface WorkDetailsView : UIScrollView

@property (strong, nonatomic) UIView *contentView;

- (instancetype)initWithWork:(XCZWork *)work width:(CGFloat)width;
- (void)updateWithWork:(XCZWork *)work;
- (void)enterFullScreenMode;
- (void)exitFullScreenMode;

@end
