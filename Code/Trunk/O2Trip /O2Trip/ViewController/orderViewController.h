//
//  orderViewController.h
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderViewController : UIViewController
{
    UIAlertView* mAlert;
    UITextField *mTextField;
    int i;
}
@property(nonatomic, retain)NSString *channel;
@property(nonatomic ,retain)UITextField *mTextField;
@property(nonatomic,strong)NSString* actiName;
@property(nonatomic,strong)NSString* actiPrice;
@property(nonatomic,strong)NSString* actiTime;
@property(nonatomic,strong)NSString* peopleNumber;
@property(nonatomic,strong)NSString* contactPeople;
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* smallPrice;
@property (weak, nonatomic) IBOutlet UILabel *actiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actiPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *usePayButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property(nonatomic,strong)NSDictionary* charge;
@property(nonatomic,strong)NSString * orderId;
- (IBAction)backButtonClick:(id)sender;
- (IBAction)surePayButtonClick:(id)sender;
- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;
@end
