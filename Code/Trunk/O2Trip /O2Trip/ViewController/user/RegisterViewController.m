//
//  RegisterViewController.m
//  O2Trip
//
//  Created by huangl on 15/3/22.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterViewController.h"
#import "UserViewModel.h"
#import "changeViewController.h"
#import "O2Trip-Swift.h"

#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"sure", nil];\
    [alertView show];

@interface RegisterViewController()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@end

@implementation RegisterViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.registLabel.layer.masksToBounds=YES;
    self.registLabel.layer.cornerRadius=2;

}
- (IBAction)registButtonClick:(id)sender {

    // TODO:
    NSString *email = self.emailTextField.text;
    NSString* password=self.passWordTextField.text;

     if ([self isMobileNumber:self.emailTextField.text])
     {
         UserViewModel *viewModel = [[UserViewModel alloc] init];
         [viewModel register:email setPassWord:password];
         
         [viewModel setBlockWithReturnBlock:^(id returnValue) {
             [SVProgressHUD dismiss];
             
             //成功
             UserModel *um=returnValue;
            //DDLog(@"%@",um.account);
             if([um.status isEqualToString:@"1"])
             {
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults setObject:email forKey:@"account"];
                 [userDefaults setObject:password forKey:@"password"];
                 [userDefaults setObject:um.loginUserId forKey:@"loginUserId"];
                 [userDefaults setObject:um.key forKey:@"key"];
                 [userDefaults setObject:um.registerDate forKey:@"registerDate"];
                 [userDefaults setObject:um.nickName forKey:@"nickName"];
                 [userDefaults setObject:um.image forKey:@"image"];
                 [userDefaults setObject:um.phone forKey:@"phone"];
                 [userDefaults setObject:um.sex forKey:@"sex"];
                 [userDefaults synchronize];
                 changeViewController* vc=[self.navigationController.viewControllers objectAtIndex:0];
                 
                 [self.navigationController popToViewController:vc animated:YES];
                
             }else
             {
                 UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名已存在重新注册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alertView show];
             }
             
         } WithErrorBlock:^(id errorCode) {
             [SVProgressHUD dismiss];
         } WithFailureBlock:^{
             [SVProgressHUD dismiss];
         }];
     }else
     {
         UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alertView show];
         
     }

     }

- (IBAction)clickVerify:(id)sender {
    // TODO:
    if (![self isMobileNumber:self.emailTextField.text]) {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    [HttpReqManager httpRequestGetVerifyCode:self.emailTextField.text completion:^(NSDictionary<NSString *,id> * _Nonnull response) {
        [self startCountingDownGetVerifyCode];
    } failure:^(NSError * _Nonnull error) {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取验证码失败，请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[6-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}

- (void)startCountingDownGetVerifyCode {}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
