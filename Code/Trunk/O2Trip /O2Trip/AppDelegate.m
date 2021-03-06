//
//  AppDelegate.m
//  O2Trip
//
//  Created by huangl on 15-3-1.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "APService.h"
//#import "Pingpp.h"
#import "orderViewController.h"
//#import "APOpenAPI.h"
#import "O2Trip-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
    [WXApi registerApp:@"wxfc5b7d0ff882adcb"];
   
    //推送
    //注册Jpush推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    // Required
    [APService setupWithOption:launchOptions];
    
    [self customNavigationBar];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL success = NO;
    if ([PayManager sharedInstance].isPaying) {
        success = [[PayManager sharedInstance] handleOpenUrl:url];
    }
    else {
        success = [[ThirdPartySignInManager defaultManager] handleOpenUrl:url];
    }
    return success;
}
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
////    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
////        // result : success, fail, cancel, invalid
////        NSString *msg;
////        if (error == nil) {
////            NSLog(@"PingppError is nil");
////            msg = result;
////        } else {
////            NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
////            msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
////        }
////        [(orderViewController*)self.viewController.visibleViewController showAlertMessage:msg];
////    }];
////    return  YES;
//
//    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
//  
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.window endEditing:YES];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
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
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customNavigationBar {
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:26 / 255.0
 green:188 / 255.0 blue:156 / 255.0 alpha:1.0]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26 / 255.0
                                                               green:188 / 255.0 blue:156 / 255.0 alpha:1.0]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:240 / 255.0
                                                                     green:240 / 255.0
                                                                      blue:240 / 255.0
                                                                     alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: [UIColor colorWithRed:48 / 255.0 green:48 / 255.0 blue:48 / 255.0 alpha:1.0]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]} forState:UIControlStateNormal];
}

@end
