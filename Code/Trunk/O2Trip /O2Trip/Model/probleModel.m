//
//  probleModel.m
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "probleModel.h"

@implementation probleModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.proId=[dic objectForKey:@"proId"];
        self.problemContent=[dic objectForKey:@"problemContent"];
        self.problemDate=[dic objectForKey:@"problemDate"];
        self.replyArray=[dic objectForKey:@"reply"];
//        self.replyContent=[dic objectForKey:@"replyContent"];
//        self.replyDate=[dic objectForKey:@"replyDate"];
        self.status=[dic objectForKey:@"status"];
        self.userImage=[dic objectForKey:@"userImage"];
        self.userName=[dic objectForKey:@"userName"];
        self.actiPrice=[dic objectForKey:@"actiPrice"];
    }
    return self;
}
@end
