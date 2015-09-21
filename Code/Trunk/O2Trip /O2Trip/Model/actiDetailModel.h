//
//  actiDetailModel.h
//  O2Trip
//
//  Created by tao on 15/5/27.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface actiDetailModel : NSObject
@property(nonatomic,strong)NSMutableArray*actiDay;
@property(nonatomic,strong)NSString*actiDesc;
@property(nonatomic,strong)NSString*actiId;
@property(nonatomic,strong)NSMutableArray*actiImg;
@property(nonatomic,strong)NSString*actiLevel;
@property(nonatomic,strong)NSString*actiNum;
@property(nonatomic,strong)NSString*actiPrice;
@property(nonatomic,strong)NSString*actiTitle;
@property(nonatomic,strong)NSString*actiType;
@property(nonatomic,strong)NSString*costNotes;
@property(nonatomic,strong)NSString*country;
@property(nonatomic,strong)NSString*days;
@property(nonatomic,strong)NSString*dissNum;
@property(nonatomic,strong)NSString*distance;
@property(nonatomic,strong)NSString*equips;
@property(nonatomic,strong)NSString*physicalStrength;
@property(nonatomic,strong)NSMutableArray*praUser;
@property(nonatomic,strong)NSString*refundNotes;
@property(nonatomic,strong)NSMutableArray* scenic;
@property(nonatomic,strong)NSMutableArray* dicArray;
@property(nonatomic,strong)NSString* isfavorite;
@property(nonatomic,strong)NSMutableArray* problemsArray;
@property(nonatomic,strong)NSString* label;
@property(nonatomic,strong)NSString* prompt;
@property(nonatomic,strong)NSString* accurateTag;
-(id)initWithDic:(NSDictionary*)dic;
@end
