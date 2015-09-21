//
//  reservationViewController.m
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "reservationViewController.h"
#import "setDataViewController.h"
#import "maxModel.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface reservationViewController ()

@end

@implementation reservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      maxModel*mModel=[self.maxArray lastObject];
    self.peoleLabel.text=[NSString stringWithFormat:@"此活动需要%@人以上才能预定",mModel.min];
    // Do any additional setup after loading the view.
    self.dateLabel.text=[NSString stringWithFormat:@"%@年%@月%@日%@", self.yearString,  self.monthString,self.dayString,self.dateString];
    NSArray* array=[self.priceString componentsSeparatedByString:@"."];
    NSString* priceString=[array objectAtIndex:0];
    self.priceLabel.text=[NSString stringWithFormat:@"￥%@",priceString];
    self.bigPriceLabel.text=[NSString stringWithFormat:@"￥%d",[self.priceString intValue]*[self.numberLabel.text intValue]];
    
 
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionButtonClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    setDataViewController* setDataVc=[SB instantiateViewControllerWithIdentifier:@"setDataViewController"];
    setDataVc.actiName=self.actiName;
    setDataVc.actiTime=self.dateLabel.text;
    setDataVc.peopleNumber=self.numberLabel.text;
    setDataVc.bigPriceString=self.bigPriceLabel.text;
    setDataVc.priceString=self.priceLabel.text;
    setDataVc.timeString=[NSString stringWithFormat:@"%@-%@-%@",self.yearString,self.monthString,self.dayString];
    
    [self.navigationController pushViewController:setDataVc animated:YES];
}
- (IBAction)increaseButtonClick:(id)sender
{
    maxModel*mModel=[self.maxArray lastObject];
    NSLog(@"%d",[self.numberLabel.text intValue]);
    NSLog(@"%d",[mModel.max intValue]);
    if ([self.numberLabel.text intValue]==[mModel.max intValue]) {
        NSString* string=[NSString stringWithFormat:@"此活动最多只能%@人出行",mModel.max];
        ALERTVIEW(string);
        NSLog(@"%d",[self.numberLabel.text intValue]);
    }else
    {
        self.numberLabel.text=[NSString stringWithFormat:@"%d",[self.numberLabel.text intValue]+1];
        
        self.bigPriceLabel.text=[NSString stringWithFormat:@"￥%d",[self.priceString intValue]*[self.numberLabel.text intValue]];
    }
   
}

- (IBAction)deCreaseButtonClick:(id)sender
{
    
     maxModel*mModel=[self.maxArray lastObject];
    if ([self.numberLabel.text intValue]==[mModel.min intValue]) {
        NSLog(@"%d",[self.numberLabel.text intValue]);
        NSString* string=[NSString stringWithFormat:@"此活动最少只能%@人出行",mModel.min];
        ALERTVIEW(string);
    }else
    {
        self.numberLabel.text=[NSString stringWithFormat:@"%d",[self.numberLabel.text intValue]-1];
        self.bigPriceLabel.text=[NSString stringWithFormat:@"￥%d",[self.priceString intValue]*[self.numberLabel.text intValue]];
    }
   
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
