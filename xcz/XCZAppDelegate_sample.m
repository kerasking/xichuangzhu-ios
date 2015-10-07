//
//  XCZAppDelegate.m
//  xcz
//
//  Created by 刘志鹏 on 14-6-28.
//  Copyright (c) 2014年 Zhipeng Liu. All rights reserved.
//

#import "XCZAppDelegate.h"
#import "XCZWorksViewController.h"
#import "XCZAuthorsViewController.h"
#import "XCZQuotesViewController.h"
#import "XCZWorkDetailViewController.h"
#import "XCZLikesViewController.h"
#import "XCZWork.h"
#import <FMDB/FMDB.h>
#import "XCZUtils.h"
#import "UIColor+Helper.h"
#import <AVOSCloud/AVOSCloud.h>
#import "IonIcons.h"
#import "DownloadFont.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define AVOSCloudAppID  @""
#define AVOSCloudAppKey @""

@implementation XCZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID clientKey:AVOSCloudAppKey];
    
    // 执行数据库拷贝
    [self copyPublicDatabase];
    [self copyUserDatabase];
    
    
    // 延迟0.5s
    usleep(500 * 1000);
    
    //    [DownloadFont asynchronouslyDownloadFont:@"STFangsong"];
    
    // 作品Nav
    XCZWorksViewController *worksController = [[XCZWorksViewController alloc] init];
    UINavigationController *worksNavController = [[UINavigationController alloc] initWithRootViewController:worksController];
    worksController.tabBarItem.title = @"偶遇";
    UIImage *authorsImg = [UIImage imageNamed:@"authors.png"];
    worksController.tabBarItem.image = authorsImg;
    
    // 文学家Nav
    XCZAuthorsViewController *authorsController = [[XCZAuthorsViewController alloc] init];
    UINavigationController *authorsNavController = [[UINavigationController alloc] initWithRootViewController:authorsController];
    authorsController.tabBarItem.title = @"文库";
    UIImage *worksImg = [UIImage imageNamed:@"works.png"];
    authorsController.tabBarItem.image = worksImg;
    
    // 名言Nav
    XCZQuotesViewController *quotesController = [[XCZQuotesViewController alloc] init];
    UINavigationController *quotesNavController = [[UINavigationController alloc] initWithRootViewController:quotesController];
    
    UIImage *infoIcon = [IonIcons imageWithIcon:ion_ios_person_outline size:34 color:[UIColor XCZSystemGrayColor]];
    UIImage *selectedInfoIcon = [IonIcons imageWithIcon:ion_ios_person_outline size:34 color:[UIColor XCZSystemTintColor]];
    quotesNavController.tabBarItem.title = @"我";
    quotesNavController.tabBarItem.image = infoIcon;
    quotesNavController.tabBarItem.selectedImage = selectedInfoIcon;
    
    // TabBar Controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[worksNavController, authorsNavController, quotesNavController];
    
    // Root Controller
    [self.window setRootViewController:tabBarController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)copyUserDatabase
{
    
    NSString *storePath = [XCZUtils getUserDatabaseFilePath];
    NSString *bundleStore = [[NSBundle mainBundle] pathForResource:@"xcz_user" ofType:@"db"];
    
    // 若Documents文件夹下不存在数据库文件，则执行拷贝
    if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSLog(@"User database not found... copy from bundle.");
        [[NSFileManager defaultManager] copyItemAtPath:bundleStore toPath:storePath error:nil];
    } else {
        NSLog(@"User database found.");
    }
}

- (void)copyPublicDatabase
{
    NSString *storePath = [XCZUtils getDatabaseFilePath];
    NSString *bundleStore = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    //NSLog(@"%@", storePath);
    
    // 若Documents文件夹下不存在数据库文件，则执行拷贝
    if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSLog(@"Public database not found... copy from bundle.");
        [[NSFileManager defaultManager] copyItemAtPath:bundleStore toPath:storePath error:nil];
    } else {
        NSLog(@"Public database found.");
        
        NSString *latestVersion;
        NSString *currentVersion;
        
        // 获取latestVersion
        @try {
            FMDatabase *db = [FMDatabase databaseWithPath:bundleStore];
            [db open];
            FMResultSet *s = [db executeQuery:@"SELECT * FROM version"];
            [s next];
            latestVersion = [s stringForColumn:@"version"];
            [db close];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        
        // 获取currentVersion
        @try {
            FMDatabase *db = [FMDatabase databaseWithPath:storePath];
            [db open];
            FMResultSet *s = [db executeQuery:@"SELECT * FROM version"];
            [s next];
            currentVersion = [s stringForColumn:@"version"];
            [db close];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        
        // 若 version 不匹配，则删除原有db，将新db复制过来
        if(![latestVersion isEqualToString:currentVersion]) {
            NSLog(@"Version not match...delete old one and copy new one from bundle.");
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];[[NSFileManager defaultManager] copyItemAtPath:bundleStore toPath:storePath error:nil];
        } else {
            NSLog(@"Version match.");
        }
    }
}

@end
