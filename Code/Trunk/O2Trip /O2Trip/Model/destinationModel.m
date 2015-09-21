//
//  destinationModel.m
//  O2Trip
//
//  Created by tao on 15/5/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "destinationModel.h"

@implementation destinationModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.actiId=[dic objectForKey:@"actiId"];
        self.actiType=[dic objectForKey:@"actiType"];
        
        self.days=[dic objectForKey:@"days"];
        self.discussNum=[dic objectForKey:@"discussNum"];
        self.origPrice=[dic objectForKey:@"origPrice"];
        self.physicalStrength=[dic objectForKey:@"physicalStrength"];
        self.praiseNum=[dic objectForKey:@"praiseNum"];
        self.specialPrice=[dic objectForKey:@"specialPrice"];
        self.tripDistance =[dic objectForKey:@"tripDistance"];
        self.actiImage=[dic objectForKey:@"actiImage"];
        self.actiTitle=[dic objectForKey:@"actiTitle"];
        self.distance=[dic objectForKey:@"distance"];
        self.descName=[dic objectForKey:@"descName"];
        self.hasPraise=[dic objectForKey:@"hasPraise"];
    }
    return self;
}
@end
