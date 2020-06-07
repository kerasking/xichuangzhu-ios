//
//  DownloadFont.h
//  xcz
//
//  Created by hustlzp on 15/9/16.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFont : NSObject

+ (BOOL)isFontDownloaded:(NSString *)fontName;
+ (void)asynchronouslyDownloadFont:(NSString *)fontName completion:(void (^)(void))completion;

@end
