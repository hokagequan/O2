//
//  GridView.h
//  O2Trip
//
//  Created by Q on 15/10/22.
//  Copyright © 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *daylabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

+ (GridView *)loadFromNib;

@end
