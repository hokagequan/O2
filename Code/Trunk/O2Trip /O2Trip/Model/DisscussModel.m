//
//  DisscussModel.m
//  O2Trip
//
//  Created by tao on 15/5/26.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "DisscussModel.h"

@implementation DisscussModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.dissContent=[dic objectForKey:@"dissContent"];
        self.dissDate=[dic objectForKey:@"dissDate"];
        self.level=[dic objectForKey:@"level"];
        self.userId=[dic objectForKey:@"userId"];
        self.userName=[dic objectForKey:@"userName"];
        self.actiPrice=[dic objectForKey:@"actiPrice"];
        self.actiTitle=[dic objectForKey:@"actiTitle"];
    }
    return self;
}
@end
