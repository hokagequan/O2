//
//  RegisterViewController.h
//  O2Trip
//
//  Created by huangl on 15/3/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    
}

- (IBAction)backButton:(id)sender;
- (IBAction)registButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *registLabel;

@end