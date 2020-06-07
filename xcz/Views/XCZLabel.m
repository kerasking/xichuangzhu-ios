//
//  XCZLabel.m
//  xcz
//
//  Created by hustlzp on 15/10/7.
//  Copyright © 2015年 Zhipeng Liu. All rights reserved.
//

#import "XCZLabel.h"

@implementation XCZLabel

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberOfLines == 0) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
    }
}

@end
