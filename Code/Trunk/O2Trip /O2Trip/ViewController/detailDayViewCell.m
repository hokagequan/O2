//
//  HomeViewCCell.m
//  O2Trip
//
//  Created by zhangwen on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "detailDayViewCell.h"
@interface detailDayViewCell ()
{
    UIPageControl *pageC;
    UIPageControl *pageC1;
}
@end
@implementation detailDayViewCell
//- (void)setScrollV:(UIScrollView *)scrollV
//{
//    scrollV.backgroundColor = [UIColor lightGrayColor];
//    
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    [image setImage:[UIImage imageNamed:@"91.jpg"]];
//    [scrollV addSubview:image];
//    
//    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV.bounds.size.width, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    
//    [image1 setImage:[UIImage imageNamed:@"92.jpg"]];
//    [scrollV addSubview:image1];
//    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV.bounds.size.width+277, 0, scrollV.bounds.size.width, scrollV.bounds.size.height)];
//    [image2 setImage:[UIImage imageNamed:@"93.jpg"]];
//    [scrollV addSubview:image2];
//    
//    
//    scrollV.pagingEnabled = YES;
//    scrollV.contentSize = CGSizeMake(scrollV.bounds.size.width * 3, 0);
//    scrollV.showsHorizontalScrollIndicator = NO;
//    
//    scrollV.delegate=self;
//    
//    pageC=[[UIPageControl alloc]init];
//    CGPoint centerP={160,235};
//    [pageC setCenter:centerP];
//    pageC.pageIndicatorTintColor=[UIColor grayColor];
//    pageC.numberOfPages=3;
//    [self addSubview:pageC];
//    
//    
//}
//
//- (void)setScrollV1:(UIScrollView *)scrollV1
//{
//    scrollV1.backgroundColor = [UIColor lightGrayColor];
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollV1.bounds.size.width, scrollV1.bounds.size.height)];
//    [image setImage:[UIImage imageNamed:@"91.jpg"]];
//    [scrollV1 addSubview:image];
//    
//    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV1.bounds.size.width, 0, scrollV1.bounds.size.width, scrollV1.bounds.size.height)];
//    
//    [image1 setImage:[UIImage imageNamed:@"92.jpg"]];
//    [scrollV1 addSubview:image1];
//    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(scrollV1.bounds.size.width+277, 0, scrollV1.bounds.size.width, scrollV1.bounds.size.height)];
//    [image2 setImage:[UIImage imageNamed:@"93.jpg"]];
//    [scrollV1 addSubview:image2];
//    
//    
//    scrollV1.pagingEnabled = YES;
//    scrollV1.contentSize = CGSizeMake(scrollV1.bounds.size.width * 3, 0);
//    scrollV1.showsHorizontalScrollIndicator = NO;
//    
//    scrollV1.delegate=self;
//    pageC1=[[UIPageControl alloc]init];
//    CGPoint centerP={160,470};
//    [pageC1 setCenter:centerP];
//    pageC1.pageIndicatorTintColor=[UIColor grayColor];
//    pageC1.numberOfPages=3;
//    [self addSubview:pageC1];
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.tag==1)
//        pageC.currentPage=scrollView.contentOffset.x/277;
//    else
//        pageC1.currentPage=scrollView.contentOffset.x/277;
//}

@end
