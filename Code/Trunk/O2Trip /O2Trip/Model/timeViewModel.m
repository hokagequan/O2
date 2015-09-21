//
//  timeViewModel.m
//  O2Trip
//
//  Created by tao on 15/9/9.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "timeViewModel.h"

@implementation timeViewModel
-(id)initWithDiconary:(NSDictionary*)dic
{
   self=[super init];
    if (self) {
        self.date=[dic objectForKey:@"date"];
        self.prices=[dic objectForKey:@"prices"];
        self.stock=[dic objectForKey:@"stock"];
    }
    return self;
}
@end
