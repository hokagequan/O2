//
//  smallDestinModel.h
//  O2Trip
//
//  Created by tao on 15/5/25.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface smallDestinModel : NSObject
@property(nonatomic,strong)NSString* typeId;
@property(nonatomic,strong)NSString* typeImg;
@property(nonatomic,strong)NSString* typeName;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
