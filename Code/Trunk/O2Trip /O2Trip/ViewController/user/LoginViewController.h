//
//  ViewController.h
//  Ｏ2Trip
//
//  Created by huanglei on 15/3/11.
//  Copyright (c) 2015年 黄磊. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

- (IBAction)otherButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
- (IBAction)backButtonClick:(id)sender;

@end

