//
//  UIView+SetFont.h
//  xcz
//
//  Created by hustlzp on 15/9/16.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SetFont)

- (void)setFontAsynchronously:(NSString *)fontName size:(CGFloat)fontSize;

@end
