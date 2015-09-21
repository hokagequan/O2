//
//  setDataViewController.h
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setDataViewController : UIViewController
- (IBAction)backButtonClick:(id)sender;
- (IBAction)setUpMsgButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *appellationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surnamesLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property(nonatomic,strong)NSString* actiName;
@property(nonatomic,strong)NSString* actiTime;
@property(nonatomic,strong)NSString* peopleNumber;
@property(nonatomic,strong)NSString* priceString;
@property(nonatomic,strong)NSString* bigPriceString;
@property(nonatomic,strong)NSString* timeString;
@property(nonatomic,strong)NSString* niChengString;
@property (weak, nonatomic) IBOutlet UILabel *actiLabel;
@property (weak, nonatomic) IBOutlet UILabel *actiTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(nonatomic,strong)NSString* hourString;
@property(nonatomic,strong)NSString* miniter;
- (IBAction)actionButtonClick:(id)sender;

@end
