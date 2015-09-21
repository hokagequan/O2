//
//  actiDetailModel.m
//  O2Trip
//
//  Created by tao on 15/5/27.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "actiDetailModel.h"

@implementation actiDetailModel
-(id)initWithDic:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.actiDay=[dic objectForKey:@"actiDay"];
        self.actiDesc=[dic objectForKey:@"actiDesc"];
        self.actiId=[dic objectForKey:@"actiId"];
        self.actiImg=[dic objectForKey:@"actiImg"];
        self.actiLevel=[dic objectForKey:@"actiLevel"];
        self.actiNum=[dic objectForKey:@"actiNum"];
        self.actiPrice=[dic objectForKey:@"actiPrice"];
        self.actiTitle=[dic objectForKey:@"actiTitle"];
        self.actiType=[dic objectForKey:@"actiType"];
        self.costNotes=[dic objectForKey:@"costNotes"];
        self.country=[dic objectForKey:@"country"];
        self.days=[dic objectForKey:@"days"];
        self.dissNum=[dic objectForKey:@"dissNum"];
        self.distance=[dic objectForKey:@"distance"];
        self.equips=[dic objectForKey:@"equips"];
        self.physicalStrength=[dic objectForKey:@"physicalStrength"];
        self.praUser=[dic objectForKey:@"praUser"];
        self.refundNotes=[dic objectForKey:@"refundNotes"];
        self.scenic=[dic objectForKey:@"scenic"];
        self.dicArray=[dic objectForKey:@"discuss"];
        self.isfavorite=[dic objectForKey:@"isfavorite"];
        self.problemsArray=[dic objectForKey:@"problems"];
        self.label=[dic objectForKey:@"label"];
        self.prompt=[dic objectForKey:@"prompt"];
        self.accurateTag=[dic objectForKey:@"accurateTag"];
        
    }
    return self;
}
@end
