//
//  probleModel.h
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface probleModel : NSObject
@property(nonatomic,strong)NSString*  proId;
@property(nonatomic,strong)NSString* problemContent;
@property(nonatomic,strong)NSString* problemDate;
@property(nonatomic,strong)NSMutableArray* replyArray;
@property(nonatomic,strong)NSString* replyContent;
@property(nonatomic,strong)NSString* replyDate;
@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* userImage;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* actiPrice;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
