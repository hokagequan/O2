//
//  lanchViewController.m
//  O2Trip
//
//  Created by tao on 15/7/10.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "lanchViewController.h"
#import "tabBarController.h"
#import "changeViewController.h"
@implementation lanchViewController
-(void)viewDidLoad
{
    self.navigationController.navigationBarHidden=YES;
    UIImageView* bg=[[UIImageView alloc]initWithFrame:self.view.frame];
    bg.image=[UIImage imageNamed:@"启动页-6S.png"];
    [self.view addSubview:bg];
    [self performSelector:@selector(moveAnimation) withObject:nil afterDelay:2];
    
}
-(void)moveAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
  
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
   tabBarController* detailVC=[SB instantiateViewControllerWithIdentifier:@"tabBarController"];

    [self.navigationController pushViewController:detailVC animated:YES];

  
    [UIView commitAnimations];
    
}
@end
