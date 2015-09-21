//
//  HomeViewACell.m
//  O2Trip
//
//  Created by zhangwen on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "detailIntroduceViewCell.h"
@interface detailIntroduceViewCell ()
{
    UIPageControl *pageC;
}
@end
@implementation detailIntroduceViewCell
//- (void)setScrollV:(UIScrollView *)scrollV
//{
//    scrollV.backgroundColor = [UIColor whiteColor];
//    
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    [image setImage:[UIImage imageNamed:@"91.jpg"]];
//    [scrollV addSubview:image];
//    
//    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV.bounds.size.width, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    
//    [image1 setImage:[UIImage imageNamed:@"92.jpg"]];
//    [scrollV addSubview:image1];
//    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV.bounds.size.width+304, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    [image2 setImage:[UIImage imageNamed:@"93.jpg"]];
//    [scrollV addSubview:image2];
//    
//    scrollV.pagingEnabled = YES;
//    scrollV.contentSize = CGSizeMake(scrollV.bounds.size.width * 3, 0);
//    scrollV.showsHorizontalScrollIndicator = NO;
//    scrollV.delegate=self;
//    
//    pageC=[[UIPageControl alloc]init];
//    CGPoint centerP={160,170};
//    [pageC setCenter:centerP];
//    pageC.pageIndicatorTintColor=[UIColor grayColor];
//    pageC.numberOfPages=3;
//    [self addSubview:pageC];
//    
//    UIImageView *image3=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV.bounds.size.width - 30, 10, 20, 20)];
//    [image3 setImage:[UIImage imageNamed:@"心11.png"]];
//    [self addSubview:image3];
//    
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    pageC.currentPage=scrollView.contentOffset.x/304;
//    
//}
@end
