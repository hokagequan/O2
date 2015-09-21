//
//  SetUpTheViewController.m
//  O2Trip
//
//  Created by zhangwen on 15/5/18.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "SetUpTheViewController.h"
#import "UserViewModel.h"
#import "feedbackViewController.h"
#import "contactViewController.h"
#import "middleViewController.h"
@interface SetUpTheViewController ()
{
   
}
@end

@implementation SetUpTheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
     NSString* userId=[userDefaults objectForKey:@"account"];
    if (userId.length==0) {
        self.exitLoginButton.alpha=0;
    }
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exitButtonClick:(id)sender
{
    UserViewModel* userVc=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* string =[userDefaults objectForKey:@"key"];
    [userVc exitLogin:string];
    
    [userVc setBlockWithReturnBlock:^(id returnValue) {
        [SVProgressHUD dismiss];
        UserModel* um=returnValue;
        if (um&&[um.status isEqualToString:@"1"]) {
            UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            alertView.delegate=self;
            alertView.tag=1;
            [alertView show];
            [userDefaults removeObjectForKey:@"account"];
            [userDefaults removeObjectForKey:@"key"];
            [userDefaults removeObjectForKey:@"loginUserId"];
            [userDefaults removeObjectForKey:@"registerDate"];
            [userDefaults removeObjectForKey:@"nickName"];
            [userDefaults removeObjectForKey:@"image"];
            [userDefaults removeObjectForKey:@"phone"];
            [userDefaults removeObjectForKey:@"imageUrl"];
            
        }else
        {
            UIAlertView* alertView1=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先登录或注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            alertView1.delegate=self;
            alertView1.tag=2;
            [alertView1 show];
            [userDefaults removeObjectForKey:@"account"];
            [userDefaults removeObjectForKey:@"key"];
            [userDefaults removeObjectForKey:@"loginUserId"];
            [userDefaults removeObjectForKey:@"registerDate"];
            [userDefaults removeObjectForKey:@"nickName"];
            [userDefaults removeObjectForKey:@"image"];
            [userDefaults removeObjectForKey:@"phone"];
            [userDefaults removeObjectForKey:@"imageUrl"];

        }
      
        
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD dismiss];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    
    

}

- (IBAction)feedbackClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    feedbackViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"feedbackViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)contactClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    contactViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"contactViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        if (alertView.tag==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            middleViewController* Vc=[SB instantiateViewControllerWithIdentifier:@"middleViewController"];
            [self.navigationController pushViewController:Vc animated:YES];        }
        
    }
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
