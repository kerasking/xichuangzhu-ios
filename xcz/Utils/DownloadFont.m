//
//  DownloadFont.m
//  xcz
//
//  Created by hustlzp on 15/9/16.
//  Copyright (c) 2015年 Zhipeng Liu. All rights reserved.
//

#import "DownloadFont.h"
#import <CoreText/CoreText.h>

@implementation DownloadFont

+ (BOOL)isFontDownloaded:(NSString *)fontName
{
    UIFont *aFont = [UIFont fontWithName:fontName size:12.0];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)asynchronouslyDownloadFont:(NSString *)fontName completion:(void (^)(void))completion
{
    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // If the font is already downloaded
    if ([self isFontDownloaded:fontName]) {
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", fontName);
                    
                    dispatch_async( dispatch_get_main_queue(), ^ {
                        NSLog(@"Finish downloading");
                        if (completion) {
                            completion();
                        }
                    });
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSString *errorMessage;
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                errorMessage = [error description];
            } else {
                errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {

                NSLog(@"Download error: %@", errorMessage);
            });
        }
        
        return (bool)YES;
    });
    
}

@end
