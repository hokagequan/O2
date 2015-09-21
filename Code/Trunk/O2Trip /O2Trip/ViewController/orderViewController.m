//
//  orderViewController.m
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "orderViewController.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include "Pingpp.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "AppDelegate.h"
#import "UserViewModel.h"
#import "UserViewModel.h"
#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kPlaceHolder      @"支付金额"
#define kMaxAmount        9999999

#define kUrlScheme      @"wxfc5b7d0ff882adcb" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#define kUrl            @"http://218.244.151.190/demo/charge"
@interface orderViewController ()

@end

@implementation orderViewController
@synthesize channel;
@synthesize mTextField;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.actiNameLabel.text=self.actiName;
    self.actiPriceLabel.text=[NSString stringWithFormat:@"%@",self.actiPrice];
    self.timeLabel.text=self.actiTime;
    self.peopleNumberLabel.text=[NSString stringWithFormat:@"%@×成人",self.peopleNumber];
    self.contactLabel.text=[NSString stringWithFormat:@"联系人:%@",self.contactPeople];
    self.phoneLabel.text=[NSString stringWithFormat:@"电话: +86 %@",self.phone];
    self.emailLabel.text=[NSString stringWithFormat:@"电子邮箱: %@",self.email];
    [self.usePayButton addTarget:self action:@selector(usePayButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.weixinButton addTarget:self action:@selector(weixinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self sendOrderRequest];
}
-(void)sendOrderRequest
{
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSArray* array=[self.smallPrice componentsSeparatedByString:@"￥"];
    self.smallPrice=[array lastObject];
    array=[self.actiTime componentsSeparatedByString:@"日"];
    NSString* hourString=[array lastObject];
    array=[self.actiPrice componentsSeparatedByString:@"￥"];
    NSString * price=[array lastObject];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* actiId=[userDefaults objectForKey:@"actiId"];
    NSString* loginUseId=[userDefaults objectForKey:@"loginUserId"];
    [userModel commitOrderPage:self.smallPrice withRealName:self.contactPeople withPhone:self.phone withStartDate:self.actiTime withTime:hourString withTotal:price withNum:self.peopleNumber withEmail:self.email withActiId:actiId withUseId:loginUseId];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        self.orderId=[returnValue lastObject];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}
//支付宝支付
-(void)usePayButtonButtonClick:(UIButton*)button
{
    self.weixinButton.backgroundColor=[UIColor clearColor];
    button.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    i=1;
}
//微信点击
-(void)weixinButtonClick:(UIButton*)button
{
    self.usePayButton.backgroundColor=[UIColor whiteColor];
    button.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
     i=2;
}
- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}
- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}
- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}
//获取ip地址
//获取设备当前ip
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
//确认支付跳转支付页
- (IBAction)surePayButtonClick:(id)sender
{
    if (i==1) {
        self.channel = @"01";
    }else if (i==2)
    {
        self.channel = @"02";
        
    }else
    {
        return;
    }
    NSArray* array=[self.actiPrice componentsSeparatedByString:@"￥"];
    long long amount=[[array lastObject] longLongValue];
    if (amount==0) {
        return;
    }
    NSString* ip=[self getIPAddress];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    [self showAlertWait];
    [userModel jumpPay:self.orderId withChannel:self.channel withClientIp:ip withCurrency:@"cny" withFlag:@"true"];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        [self hideAlert];
        NSLog(@"zcharge=%@",returnValue);
        [self performSelector:@selector(pingPP:) withObject:returnValue afterDelay:0.5];
        

    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    
}
-(void)pingPP:(NSString*)returnValue
{
    [Pingpp createPayment:returnValue viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
        NSLog(@"completion block: %@", result);
        
        NSLog(@"error==%@",error);
        [self showAlertMessage:result];
    }];

}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
