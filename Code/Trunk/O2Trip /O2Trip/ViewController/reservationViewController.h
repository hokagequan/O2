//
//  reservationViewController.h
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reservationViewController : UIViewController
- (IBAction)backButtonClick:(id)sender;
- (IBAction)actionButtonClick:(id)sender;
@property(nonatomic,strong)NSString* yearString;
@property(nonatomic,strong)NSString* monthString;
@property(nonatomic,strong)NSString* dayString;
@property(nonatomic,strong)NSString* dateString;
@property(nonatomic,strong)NSString* priceString;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property(nonatomic,strong)NSMutableArray* maxArray;
@property(nonatomic,strong)NSString* actiName;
@property(nonatomic,strong)NSString* actiId;
- (IBAction)increaseButtonClick:(id)sender;
- (IBAction)deCreaseButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *peoleLabel;
@end
