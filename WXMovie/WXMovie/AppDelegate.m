//
//  AppDelegate.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "GuideViewController.h"
#import "LaunchViewController.h"
#import "UncaughtExceptionHandler.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    InstallUncaughtExceptionHandler();

    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    BOOL showGuide = [userDetaults boolForKey:@"showGuide"];
    if (showGuide == NO) { //没有显示操作指南，则显示
        self.window.rootViewController = [[[GuideViewController alloc] init] autorelease];
        
        [userDetaults setBool:YES forKey:@"showGuide"];
        //将数据同步到本地的文件中
        [userDetaults synchronize];
    } else {
        self.window.rootViewController = [[[LaunchViewController alloc] init] autorelease];
    }
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
