//
//  deModel.h
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface deModel : NSObject
@property(nonatomic,strong)NSString* actiNum;
@property(nonatomic,strong)NSString* destiId;
@property(nonatomic,strong)NSString* destiImg;
@property(nonatomic,strong)NSString* destiName;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
