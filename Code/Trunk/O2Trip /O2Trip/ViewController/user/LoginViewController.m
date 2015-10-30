//
//  ViewController.m
//  O2Trip
//
//  Created by huangl on 15-3-1.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewModel.h"
#import "mapViewController.h"
#import "changeViewController.h"

#import "O2Trip-Swift.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *weboButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;

@end

@implementation LoginViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBarHidden=YES;
    self.loginLabel.layer.masksToBounds=YES;
    self.loginLabel.layer.cornerRadius=2;
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//    NSString* sting= [userDefaults objectForKey:@"loginUserId"];
//    if (sting) {
//        <#statements#>
//    }

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {   
    
    NSString *account = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    
    if (account.length>0 && password.length>0) {
        
        UserViewModel *viewModel = [[UserViewModel alloc] init];
        [viewModel login:account setPassWord:password];
        
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [SVProgressHUD dismiss];
            //成功登录后
            UserModel* um=returnValue;
            if (um&&[um.status isEqualToString:@"200"]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:account forKey:@"account"];
                [userDefaults setObject:password forKey:@"password"];
                [userDefaults setObject:um.loginUserId forKey:@"loginUserId"];
                [userDefaults setObject:um.key forKey:@"key"];
                [userDefaults setObject:um.registerDate forKey:@"registerDate"];
                [userDefaults setObject:um.nickName forKey:@"nickName"];
                [userDefaults setObject:um.image forKey:@"image"];
                [userDefaults setObject:um.phone forKey:@"phone"];
                [userDefaults setObject:um.sex forKey:@"sex"];
                [userDefaults setObject:um.image forKey:@"imageUrl"];
                [userDefaults synchronize];
                changeViewController* vc=[self.navigationController.viewControllers objectAtIndex:0];
                [self.navigationController popToViewController:vc animated:YES];
            }else
            {
                [self showAlertView];
            }
           
            
        } WithErrorBlock:^(id errorCode) {
            [SVProgressHUD dismiss];
        } WithFailureBlock:^{
            [SVProgressHUD dismiss];
        }];
    }else
    {
        
        UIAlertView* alerView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"所有输入不能为空"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alerView show];

    }
    
    
    
}
-(void)showAlertView
{
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名不存在或密码错误请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alertView show];
    
}

- (IBAction)otherButtonClick:(id)sender
{
    
//    UIButton* button=(UIButton*)sender;
//    if (button.tag==3) {
//        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//            
//            if (result) {
//                changeViewController* vc=[self.navigationController.viewControllers objectAtIndex:0];
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }];
//        
//    }else if (button.tag==2)
//    {
//        
//        [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//            if (result) {
//                changeViewController* vc=[self.navigationController.viewControllers objectAtIndex:0];
//                [self.navigationController popToViewController:vc animated:YES];            }
//        }];
//    }else
//    {
//        //[ShareSDK cancelAuthWithType:ShareTypeQQSpace];
//        [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//            if (result) {
//                changeViewController* vc=[self.navigationController.viewControllers objectAtIndex:0];
//                [self.navigationController popToViewController:vc animated:YES];            }
//        }];
//    }
   

}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)clickWeibo:(id)sender {
}

- (IBAction)clickQQ:(id)sender {
}

- (IBAction)clickWechat:(id)sender {
}

@end
