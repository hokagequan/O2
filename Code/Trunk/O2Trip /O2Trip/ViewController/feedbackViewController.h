//
//  feedbackViewController.h
//  O2Trip
//
//  Created by tao on 15/8/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedbackViewController : UIViewController
{
    int  _keyHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
- (IBAction)backButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *mytextView;
- (IBAction)submitButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *feedTextField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@end
