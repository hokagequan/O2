//
//  collectionModel.m
//  O2Trip
//
//  Created by tao on 15/5/22.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "collectionModel.h"

@implementation collectionModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.actiId=[dic objectForKey:@"actiId"];
        self.actiTitle=[dic objectForKey:@"actiTitle"];
        self.country=[dic objectForKey:@"country"];
        self.price=[dic objectForKey:@"price"];
        self.type=[dic objectForKey:@"type"];
        self.url=[dic objectForKey:@"url"];
        self.tripDistance=[dic objectForKey:@"tripDistance"];
        self.days=[dic objectForKey:@"days"];
        self.praiseNum=[dic objectForKey:@"praiseNum"];
        self.hasPraise=[dic objectForKey:@"hasPraise"];
        
    }
    return self;
}
@end
