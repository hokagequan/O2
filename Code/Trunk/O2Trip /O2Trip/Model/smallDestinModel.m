//
//  smallDestinModel.m
//  O2Trip
//
//  Created by tao on 15/5/25.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "smallDestinModel.h"

@implementation smallDestinModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.typeId=[dic objectForKey:@"typeId"];
        self.typeImg=[dic objectForKey:@"typeImg"];
        self.typeName=[dic objectForKey:@"typeName"];
    }
    return self;
}
@end
