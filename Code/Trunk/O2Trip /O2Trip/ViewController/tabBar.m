//
//  tabBar.m
//  O2Trip
//
//  Created by tao on 15/8/10.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "tabBar.h"

@interface tabBar ()

@end

@implementation tabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.tabBar.backgroundColor=[UIColor whiteColor];
    UITabBar* tabbar=self.tabBar;
   self.tabbar.frame=CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    UITabBarItem* item0=[tabbar.items objectAtIndex:0];
    UITabBarItem* item1=[tabbar.items objectAtIndex:1];
    UITabBarItem* item2=[tabbar.items objectAtIndex:2];
    item0.selectedImage=[[UIImage imageNamed:@"tab@2x-02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image=[UIImage imageNamed:@"tab@2x-05.png"];
    item1.selectedImage=[[UIImage imageNamed:@"tab@2x-01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image=[UIImage imageNamed:@"tab@2x-04.png"];
    item2.selectedImage=[[UIImage imageNamed:@"tab@2x-03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image=[UIImage imageNamed:@"tab@2x-06.png"];
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
