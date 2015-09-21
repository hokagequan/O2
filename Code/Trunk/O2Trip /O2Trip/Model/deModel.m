//
//  deModel.m
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "deModel.h"

@implementation deModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.actiNum=[dic objectForKey:@"actiNum"];
        self.destiId=[dic objectForKey:@"destiId"];
        self.destiImg=[dic objectForKey:@"destiImg"];
        self.destiName=[dic objectForKey:@"destiName"];
    }
    return self;
}
@end
