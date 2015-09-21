//
//  timeViewModel.h
//  O2Trip
//
//  Created by tao on 15/9/9.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface timeViewModel : NSObject
@property(nonatomic,strong)NSString* date;
@property(nonatomic,strong)NSString* prices;
@property(nonatomic,strong)NSString* stock;
-(id)initWithDiconary:(NSDictionary*)dic;
@end
