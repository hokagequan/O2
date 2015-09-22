//
//  AppDelegate.m
//  O2Trip
//
//  Created by huangl on 15-3-1.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "APService.h"
#import "Pingpp.h"
#import "orderViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
    [ShareSDK registerApp:@"71f3ecb48ce9"];
    [ShareSDK connectSinaWeiboWithAppKey:@"256180517" appSecret:@"481eb6a38f97837b9e5cd9fda640e9bc" redirectUri:@"http://www.baidu.com"];
    [ShareSDK connectWeChatWithAppId:@"wx6f2a2f4d08139d23" appSecret:@"37c79f56c3538445b9f32c89168db685 " wechatCls:[WXApi class]];
    [ShareSDK connectQQWithQZoneAppKey:@"1104546609" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
   
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
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        NSString *msg;
        if (error == nil) {
            NSLog(@"PingppError is nil");
            msg = result;
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
            msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
        }
        [(orderViewController*)self.viewController.visibleViewController showAlertMessage:msg];
    }];
    return  YES;

    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
  
}
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
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]} forState:UIControlStateNormal];
}

@end
