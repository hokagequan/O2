//
//  activityModel.m
//  O2Trip
//
//  Created by tao on 15/5/22.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "activityModel.h"

@implementation activityModel
-(id)initWithDictonary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.countryId=[dic objectForKey:@"countryId"];
        self.countryImg=[dic objectForKey:@"countryImg"];
        self.countryName=[dic objectForKey:@"countryName"];
    }
    return self;
}
@end
