//
//  UIColor+Helper.m
//  
//
//  Created by hustlzp on 15/8/17.
//
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithRGBA:(NSUInteger)color
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}

+ (UIColor *)XCZMainColor
{
    return [self colorWithRGBA:0x92130AFF];
}

+ (UIColor *)XCZSystemTintColor
{
    return [self colorWithRGBA:0x007AFFFF];
}

+ (UIColor *)XCZSystemGrayColor
{
    return [self colorWithRGBA:0x929292FF];
}

@end
