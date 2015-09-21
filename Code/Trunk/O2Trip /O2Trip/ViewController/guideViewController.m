//
//  guideViewController.m
//  O2Trip
//
//  Created by tao on 15/7/13.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "guideViewController.h"
#import "tabBar.h"
@interface guideViewController ()

@end

@implementation guideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
   
    // Do any additional setup after loading the view.
    CGFloat height=ScreenHeight;
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* user=[userDefaults objectForKey:@"b"];
    if (user.length==0) {
        UIImageView* bg=[[UIImageView alloc]initWithFrame:self.view.frame];
        NSString* placeHold;
        if (height==480) {
            placeHold=@"startpage4.jpg";
        }else if (height==568)
        {
            placeHold=@"startpage5.jpg";
        }else if (height==667)
        {
            placeHold=@"startpage6.jpg";
        }else if (height==736)
        {
            placeHold=@"startpage6s.jpg";
        }
        bg.image=[UIImage imageNamed:placeHold];
        [self.view addSubview:bg];
        [userDefaults setObject:@"1" forKey:@"b"];
        self.enterButton.userInteractionEnabled=YES;
        [self.enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
   
        self.enterButton.alpha=0;
        self.enterButton.userInteractionEnabled=NO;
        [self performSelector:@selector(showTab) withObject:nil afterDelay:0.1];
    }
}
-(void)enterButtonClick:(UIButton*)button
{
   
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabBar* detailVC=[SB instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController pushViewController:detailVC animated:NO];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showTab
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabBar* detailVC=[SB instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController pushViewController:detailVC animated:NO];
   
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
