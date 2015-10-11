//
//  CustomObjectUtil.h
//  com.eading.wireless
//
//  Created by Q on 14/12/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CustomObjectUtil : NSObject

+ (void)customObject:(NSArray *)views
    backgroundColor:(UIColor *)backgroundColor
         borderWith:(CGFloat)borderWidth
        borderColor:(UIColor *)borderColor
             corner:(CGFloat)corner;

+ (void)customNavigationBarColor:(UIColor *)naviColor itemColor:(UIColor *)itemColor;
+ (void)customNavigationBarTitleFont:(UIFont *)font color:(UIColor *)color;
+ (void)customHideNavigationBarBackTitle;

@end
