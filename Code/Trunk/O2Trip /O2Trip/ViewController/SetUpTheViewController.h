//
//  SetUpTheViewController.h
//  O2Trip
//
//  Created by zhangwen on 15/5/18.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUpTheViewController : UIViewController
- (IBAction)backButtonClick:(id)sender;
- (IBAction)exitButtonClick:(id)sender;
- (IBAction)feedbackClick:(id)sender;
- (IBAction)contactClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *exitLoginButton;


@end
