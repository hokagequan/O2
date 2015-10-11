//
//  CustomObjectUtil.m
//  com.eading.wireless
//
//  Created by Q on 14/12/15.
//
//

#import "CustomObjectUtil.h"

@implementation CustomObjectUtil

+ (void)customObject:(NSArray *)views backgroundColor:(UIColor *)backgroundColor borderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor corner:(CGFloat)corner {
    for (UIView *view in views) {
        view.backgroundColor = backgroundColor;
        view.layer.borderWidth = borderWidth;
        view.layer.borderColor = borderColor.CGColor;
        view.layer.cornerRadius = corner;
        view.layer.masksToBounds = YES;
    }
}

+ (void)customNavigationBarColor:(UIColor *)naviColor itemColor:(UIColor *)itemColor {
    [[UINavigationBar appearance] setBarTintColor:naviColor];
    [[UINavigationBar appearance] setTintColor:itemColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: itemColor}
                                                forState:UIControlStateNormal];
    
    [self customNavigationBarTitleFont:[UIFont systemFontOfSize:16.0] color:itemColor];
}

+ (void)customNavigationBarTitleFont:(UIFont *)font color:(UIColor *)color {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font}];
}

+ (void)customHideNavigationBarBackTitle {
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

@end
