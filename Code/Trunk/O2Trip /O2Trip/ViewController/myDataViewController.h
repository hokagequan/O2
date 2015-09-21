//
//  myDataViewController.h
//  O2Trip
//
//  Created by tao on 15/8/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDataViewController : UIViewController
- (IBAction)upheadButtonClick:(id)sender;
- (IBAction)changeNameButtonClick:(id)sender;
- (IBAction)chengeSexButtonClick:(id)sender;
- (IBAction)BindingphoneButtonClick:(id)sender;
- (IBAction)backButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabe;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;


@end
