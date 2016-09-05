//
//  AppDelegate.m
//  StarWallpaper
//
//  Created by Fnoz on 16/4/1.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "AppDelegate.h"
#import "SWConstDef.h"
#import "CRToast.h"
#import "UMMobClick/MobClick.h"
#import "SWHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UMConfigInstance.appKey = kUMengAppKey;
    UMConfigInstance.channelId = @"iOS";
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self initCRToast];
    
    NSString *keyword = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyword];
    if (!keyword || keyword.length<=0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"贝克汉姆" forKey:kKeyword];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initCRToast {
    [CRToastManager setDefaultOptions:@{
                                        kCRToastNotificationTypeKey : @(CRToastTypeStatusBar),
                                        kCRToastFontKey             : SWFontOfSize(17),
                                        kCRToastTextColorKey        : [UIColor whiteColor],
                                        kCRToastBackgroundColorKey  : [UIColor orangeColor],
                                        kCRToastAutorotateKey       : @(YES)}];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UIViewController *vc = [self getCurrentVC];
    while (![vc isKindOfClass:[SWHomeViewController class]]) {
        [vc dismissViewControllerAnimated:NO completion:nil];
        vc = [self getCurrentVC];
    }
    if ([shortcutItem.localizedTitle isEqualToString:@"收藏"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([vc isKindOfClass:[SWHomeViewController class]]) {
                [(SWHomeViewController *)vc likeBtnClicked];
            }
        });
    }
    else if ([shortcutItem.localizedTitle isEqualToString:@"搜索"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([vc isKindOfClass:[SWHomeViewController class]]) {
                [(SWHomeViewController *)vc keywordClicked];
            }
        });
    }
    else if ([shortcutItem.localizedTitle isEqualToString:@"反馈"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([vc isKindOfClass:[SWHomeViewController class]]) {
                [(SWHomeViewController *)vc settingClicked];
            }
        });
    }
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
