//
//  webViewController.m
//  O2Trip
//
//  Created by tao on 15/8/7.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "webViewController.h"
#import "GiFHUD.h"
@interface webViewController ()<UIWebViewDelegate>

@end

@implementation webViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
     [self performSelector:@selector(showjuhua) withObject:nil afterDelay:2.0f];
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(8, 26, 16, 16);
    [back setBackgroundImage:[UIImage imageNamed:@"@3x_ install-04.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIWebView* webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.o2lx.com"]]];
    webView.scalesPageToFit = YES;//自适应大小
    webView.delegate = self;
    [self.view addSubview:webView];
    [self.view addSubview:back];
}
-(void)showjuhua
{
    [GiFHUD dismiss];
}
-(void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
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
