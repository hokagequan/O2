//
//  GridView.m
//  O2Trip
//
//  Created by Q on 15/10/22.
//  Copyright © 2015年 lst. All rights reserved.
//

#import "GridView.h"

@implementation GridView

+ (GridView *)loadFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"GridView" owner:self options:nil];
    for (UIView *subView in views) {
        if ([subView isKindOfClass:[GridView class]]) {
            return (GridView *)subView;
        }
    }
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
