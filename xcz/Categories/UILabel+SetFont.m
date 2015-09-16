//
//  UIView+SetFont.m
//  xcz
//
//  Created by hustlzp on 15/9/16.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import "UILabel+SetFont.h"
#import "DownloadFont.h"

@implementation UILabel (SetFont)

- (void)setFontAsynchronously:(NSString *)fontName size:(CGFloat)fontSize
{
    if (![DownloadFont isFontDownloaded:fontName]) {
        NSLog(@"1");
        self.font = [UIFont systemFontOfSize:fontSize];
    } else {
        NSLog(@"2");
        self.font = [UIFont fontWithName:fontName size:fontSize];
        return;
    }
    
    [DownloadFont asynchronouslyDownloadFont:fontName completion:^{
        NSLog(@"3");
        self.font = [UIFont fontWithName:fontName size:fontSize];
    }];
}

@end
