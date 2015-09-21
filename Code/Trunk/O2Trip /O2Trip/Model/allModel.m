//
//  allModel.m
//  O2Trip
//
//  Created by tao on 15/7/7.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "allModel.h"

@implementation allModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.actiId=[dic objectForKey:@"actiId"];
        self.actiName=[dic objectForKey:@"actiName"];
        self.destiName=[dic objectForKey:@"destiName"];
        self.fsLatitude=[dic objectForKey:@"fsLatitude"];
        self.fsLongtitude=[dic objectForKey:@"fsLongtitude"];
    }
    return self;
}
@end
