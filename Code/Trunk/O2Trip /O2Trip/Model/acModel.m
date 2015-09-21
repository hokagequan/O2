//
//  acModel.m
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "acModel.h"

@implementation acModel
-(id)initWithDictionanry:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.actiId=[dic objectForKey:@"actiId"];
        self.actiImage=[dic objectForKey:@"actiImage"];
        self.actiTitle=[dic objectForKey:@"actiTitle"];
        self.actiType=[dic objectForKey:@"actiType"];
        self.days=[dic objectForKey:@"days"];
        self.descName=[dic objectForKey:@"descName"];
        self.discussNum=[dic objectForKey:@"discussNum"];
        self.distance=[dic objectForKey:@"distance"];
        self.hasPraise=[dic objectForKey:@"hasPraise"];
        self.origPrice=[dic objectForKey:@"origPrice"];
        self.physicalStrength=[dic objectForKey:@"physicalStrength"];
        self.praiseNum=[dic objectForKey:@"praiseNum"];
        self.specialPrice=[dic objectForKey:@"specialPrice"];
        self.tripDistance=[dic objectForKey:@"tripDistance"];
    }
    return self;
}
@end
