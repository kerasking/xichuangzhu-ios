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
#import "XCZWork.h"
#import <FMDB/FMDB.h>
#import "XCZUtils.h"
#import <AVOSCloud/AVOSCloud.h>

#define AVOSCloudAppID  @""
#define AVOSCloudAppKey @""

@implementation XCZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID clientKey:AVOSCloudAppKey];
    
    NSString *storePath = [XCZUtils getDatabaseFilePath];
    NSString *bundleStore = [[NSBundle mainBundle] pathForResource:@"xcz" ofType:@"db"];
    //NSLog(@"%@", storePath);
    
    // 若Documents文件夹下不存在数据库文件，则执行拷贝
    if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSLog(@"File not found... copy from bundle.");
        [[NSFileManager defaultManager] copyItemAtPath:bundleStore toPath:storePath error:nil];
    } else {
        NSLog(@"File found.");
        
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
    
    // 向用户申请通知权限
    /*
     if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
     [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
     }
     
     // app尚未运行时，处理local notification
     UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
     if (localNotif) {
     [self handleLocalNotification:localNotif];
     }
     */
    
    // Override point for customization after application launch.
    
    // 延迟0.5s
    usleep(500 * 1000);
    
    // 作品Nav
    XCZWorksViewController *worksController = [[XCZWorksViewController alloc] init];
    UINavigationController *worksNavController = [[UINavigationController alloc] initWithRootViewController:worksController];
    worksNavController.tabBarItem.title = @"作品";
    UIImage *worksImg = [UIImage imageNamed:@"works.png"];
    worksNavController.tabBarItem.image = worksImg;
    
    // 文学家Nav
    XCZAuthorsViewController *authorsController = [[XCZAuthorsViewController alloc] init];
    UINavigationController *authorsNavController = [[UINavigationController alloc] initWithRootViewController:authorsController];
    authorsNavController.tabBarItem.title = @"文学家";
    UIImage *authorsImg = [UIImage imageNamed:@"authors.png"];
    authorsNavController.tabBarItem.image = authorsImg;
    
    // 名言Nav
    XCZQuotesViewController *quotesController = [[XCZQuotesViewController alloc] init];
    UINavigationController *quotesNavController = [[UINavigationController alloc] initWithRootViewController:quotesController];
    quotesNavController.tabBarItem.title = @"摘录";
    quotesNavController.tabBarItem.image = [UIImage imageNamed:@"quotes.png"];
    
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

/*
 // 处理local notification
 - (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification {
 UIApplicationState state = [app applicationState];
 if (state != UIApplicationStateActive) {
 [self handleLocalNotification:notification];
 }
 }
 
 // 处理local notification
 - (void)handleLocalNotification:(UILocalNotification *)notification
 {
 [[NSNotificationCenter defaultCenter] postNotificationName:@"openWorkView" object:nil userInfo:notification.userInfo];
 }
 */

@end
