//
//  UserViewModel.m
//  O2Trip
//
//  Created by huangl on 15-3-15.
//  Copyright (c) 2015年 lst. All rights reserved.
//


#import "UserViewModel.h"
#import "destinationModel.h"
#import "collectionModel.h"
#import "activityModel.h"
#import "smallDestinModel.h"
#import "cancelModel.h"
#import "DisscussModel.h"
#import "actiDetailModel.h"
#import "GiFHUD.h"
#import "probleModel.h"
#import "timeModel.h"
#import "allModel.h"
#import "acModel.h"
#import "deModel.h"
#import "timeViewModel.h"
#import "maxModel.h"
#import "O2Trip-Swift.h"
@implementation UserViewModel

-(void) login:(NSString *) account setPassWord :(NSString *) password{
    
    //DDLog(@"-------------account------------%@",account);
    
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"account\":\"%@\",",account];
    [paramjsonV appendFormat:@"\"password\":\"%@\"",password];
    [paramjsonV appendFormat:@"}"];
    
     NSDictionary *parameter = @{PARAMJSON:paramjsonV};
   // NSLog(@"---%@",parameter);
 NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_login/login"];
       [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
         //DDLog(@"============%@", returnValue);
        [self fetchValueSuccessWithDic:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
       // DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
    
}
-(void)exitLogin:(NSString*)key
{
      NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"ws_login_session_to_content_key\":\"%@\"",key];
    [paramjsonV appendFormat:@"}"];
    NSDictionary* parameter=@{PARAMJSON:paramjsonV};
    //NSLog(@"*****%@",parameter);
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_logout/logout"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"============%@", returnValue);
        [self fetchValueSuccessWithDic:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

    
}

-(void) register:(NSString *) email setPassWord :(NSString *) password code:(NSString *)code {
    [HttpReqManager httpRequestSignUp:email password:password code:code completion:^(NSDictionary<NSString *,id> * _Nonnull response) {
        [self fetchValueSuccessWithDic:response];
    } failure:^(NSError * _Nullable error) {
        [self errorCodeWithDic:nil];
    }];
    
//    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
//    [paramjsonV appendFormat:@"{"];
//    [paramjsonV appendFormat:@"\"email\":\"%@\",",email];
//    [paramjsonV appendFormat:@"\"password\":\"%@\"",password];
//    [paramjsonV appendFormat:@"}"];
//    
//    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
//    
//    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_register_user/register"];
//    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
//        
//        
//        
//        DDLog(@"%@", returnValue);
//        [self fetchValueSuccessWithDic:returnValue];
//      
//    } WithErrorCodeBlock:^(id errorCode) {
//        DDLog(@"%@", errorCode);
//        [self errorCodeWithDic:errorCode];
//        
//    } WithFailureBlock:^{
//        [self netFailure];
//        DDLog(@"网络异常");
//        
//    }];

}
-(void)getDetailDestination:(NSString*)countryName withlatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId
{
    
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"countryName\":\"%@\",",countryName];
     [paramjsonV appendFormat:@"\"latitude\":\"%f\",",latitude];
     [paramjsonV appendFormat:@"\"longitude\":\"%f\",",longitude];
    [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/findActiByCountryNamePosition"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
       // DDLog(@"=%@", returnValue);
        //[self fetchValueSuccessWithDic:returnValue];
        [self getDestinationSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
}
//收藏
-(void)getCollection:(NSString*)userID setPage:(NSString*)page setNum:(NSString*)num
{
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userID];
    [paramjsonV appendFormat:@"\"page\":\"%@\",",page];
    [paramjsonV appendFormat:@"\"num\":\"%@\"",num];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/getFavouritesByUser"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
       DDLog(@"%@", returnValue);
        [self getCOllectionSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
//获得目的地页面数据成功后处理数据
-(void)getDestinationSuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"acti"];
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
       // NSLog(@"dic==%@",dic);
        destinationModel* desModel=[[destinationModel alloc]initWithDictionary:dic];
        
        [array1 addObject:desModel];
        
    }
    self.returnBlock(array1);
   // NSLog(@"======------%@",array);
}
-(void)getCOllectionSuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"favorite"];
   
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
       
        collectionModel* collmodel=[[collectionModel alloc]initWithDictionary:dic];
        [array1 addObject:collmodel];
      
    }
    self.returnBlock(array1);
}
#pragma 获取到正确的数据，对正确的数据进行处理
-(void)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    //  NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
    NSDictionary *dict = returnValue[@"data"];
    UserModel *userModel = [[UserModel alloc] init];
    userModel.account= dict[@"user"][@"account"];
    userModel.loginUserId= dict[@"user"][@"loginUserId"];
    userModel.status=returnValue[@"err_code"];
    userModel.userName=dict[@"user"][@"userName"];
    userModel.key= dict[@"user"][@"session_id_key"];
    userModel.registerDate=dict[@"user"][@"registerDate"];
    userModel.nickName=dict[@"user"][@"nickName"];
    userModel.phone=dict[@"user"][@"phone"];
    userModel.sex=dict[@"user"][@"sex"];
    userModel.image=dict[@"user"][@"image"];
    //DDLog(@"%@", returnValue[@"user"][@"loginUserId"]);
    self.returnBlock(userModel);
}
-(void)getActivity
{
   
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getCountryAndType"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
         DDLog(@"=%@", returnValue);
        //[self fetchValueSuccessWithDic:returnValue];
        [self getActivitySuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getActivitySuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"country"];
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        activityModel* actiModel=[[activityModel alloc]initWithDictonary:dic];
        [array1 addObject:actiModel];
        
    }
    NSArray* array2=[[NSArray alloc]init];
    array2=returnValue[@"data"][@"type"];
    for (NSDictionary* dic in array2) {
        smallDestinModel* smallModel=[[smallDestinModel alloc]initWithDictionary:dic];
        [array1 addObject:smallModel];
    }
    self.returnBlock(array1);
}
//详细活动页面
-(void)getdetailActivity:(NSString*)actiType withlatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId
{
    
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/findActiByTypePosition"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"actiType\":\"%@\",",actiType];
    [paramjsonV appendFormat:@"\"latitude\":\"%f\",",latitude];
    [paramjsonV appendFormat:@"\"longitude\":\"%f\",",longitude];
    [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
    [paramjsonV appendFormat:@"}"];
     NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self getdetailActivitySuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getdetailActivitySuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"acti"];
    //NSLog(@"%@",array);
     NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        destinationModel* destinModel=[[destinationModel alloc]initWithDictionary:dic];
        [array1 addObject:destinModel];
        
    }
    self.returnBlock(array1);
    
}
-(void)getdestination:(NSString*)countryName withLatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/findActiByCountryId"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"countryId\":\"%@\",",countryName];
    [paramjsonV appendFormat:@"\"latitude\":\"%f\",",latitude];
    [paramjsonV appendFormat:@"\"longitude\":\"%f\",",longitude];
    [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
    [paramjsonV appendFormat:@"}"];
   // NSLog(@"====%@",paramjsonV);
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        
        [self getdestinationSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
    

}
-(void)getdestinationSuccess:(NSDictionary*)returnValue
{
     NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"acti"];
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        destinationModel* destinaModel=[[destinationModel alloc]initWithDictionary:dic];
        [array1 addObject:destinaModel];
    }
    self.returnBlock(array1);
}
-(void)cancelCollection:(NSString*)userId withactiId:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/cancelFavourite"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userId];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        //DDLog(@"=%@", returnValue);
        [self cancelcollectionSuccess:returnValue];
            } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
}
-(void)cancelcollectionSuccess:(NSDictionary*)returnValue
{
    cancelModel * canModel=[[cancelModel alloc]init];
    canModel.flag=returnValue[@"flag"];
    canModel.msg=returnValue[@"msg"];
    self.returnBlock(canModel);

    
}
-(void)clipprais:(NSString *)userId withactiId:(NSString *)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/addPraise"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userId];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        if (returnValue) {
            
        }
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
}
-(void)clippraise:(NSString*)userId withactiId:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/addPraise"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userId];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self clippraiseSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)clippraiseSuccess:(NSDictionary*)returnValue
{
    NSString*number=returnValue[@"data"][@"Praise"][@"number"];
        self.returnBlock(number);
}
-(void)getDiscusses:(NSString*)userId setPage:(NSString*)page setNum:(NSString*)num
{
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userId];
    [paramjsonV appendFormat:@"\"page\":\"%@\",",page];
    [paramjsonV appendFormat:@"\"num\":\"%@\"",num];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/getDiscussByUser"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"%@", returnValue);
        [self getdiscussesSuccess:returnValue];
           } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getdiscussesSuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"disscuss"];
    NSMutableArray * array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        DisscussModel* dissModel=[[DisscussModel alloc]initWithDictionary:dic];
        [array1 addObject:dissModel];
    }
    self.returnBlock(array1);
}
-(void)getcollectionDetail:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getActiInfo"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        
            } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void) homeXQ:(NSString *) actiId withUserId:(NSString*)useId
{
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\",",actiId];
    [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getActiInfo"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"----------------------成功");
        DDLog(@"++++========++++%@",returnValue);
        [self homeXQSucess:returnValue];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"=-=-=-=%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
     
        DDLog(@"网络异常");
       
    }];

}
-(void)homeXQSucess:(NSDictionary*)returnValue
{
    NSDictionary*dic=[[NSDictionary alloc]init];
    dic=returnValue[@"data"][@"actiInfo"];
    //NSLog(@"dic===%@",dic);
    NSMutableArray* array=[[NSMutableArray alloc]initWithCapacity:0];
    actiDetailModel* detailModel=[[actiDetailModel alloc]initWithDic:dic];
    [array addObject:detailModel];
    NSDictionary* dic1=[[NSDictionary alloc]init];
    dic1=returnValue[@"data"][@"priceTime"];
    //NSLog(@"dic1===%@",dic1);
    timeModel* tiModel=[[timeModel alloc]initWithDictionary:dic1];
    [array addObject:tiModel];
   
    self.returnBlock(array);
    
    
}
-(void)addCollect:(NSString*)loginUserId withactiId:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/addfavoriteActi"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"loginUserId\":\"%@\",",loginUserId];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self addCollect:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)addCollect:(NSDictionary*)returnValue
{
    NSString* msg=returnValue[@"msg"];
    self.returnBlock(msg);
}
-(void)adddiscum:(NSString*)loginUesrId withActiId:(NSString*)actiId withLevel:(NSString*)level withcontext:(NSString*)context
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/addDiscuss"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"loginUesrId\":\"%@\",",loginUesrId];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\",",actiId];
    [paramjsonV appendFormat:@"\"level\":\"%@\",",level];
    [paramjsonV appendFormat:@"\"context\":\"%@\"",context];
    [paramjsonV appendFormat:@"}"];
    
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self adddiscmSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)adddiscmSuccess:(NSDictionary*)returnValue
{
    NSString* flag=returnValue[@"flag"];
    self.returnBlock(flag);
}
-(void)addProblem:(NSString*)loginUserId withprogramContent:(NSString*)programContent withActiId:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/addProblem"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"loginUserId\":\"%@\",",loginUserId];
    [paramjsonV appendFormat:@"\"programContent\":\"%@\",",programContent];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\"",actiId];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getprogram:(NSString*)userId withPage:(NSString*)page withNum:(NSString*)num
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/getProblemsByUser"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"userId\":\"%@\",",userId];
    [paramjsonV appendFormat:@"\"page\":\"%@\",",page];
    [paramjsonV appendFormat:@"\"num\":\"%@\"",num];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self getprogramSeccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getprogramSeccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"problems"];
    NSMutableArray * array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        probleModel* proModel=[[probleModel alloc]initWithDictionary:dic];
        [array1 addObject:proModel];
    }
    self.returnBlock(array1);
}
-(void)getgetDestiPostions
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getDestiPostions"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        //DDLog(@"=%@", returnValue);
        [self getDestiPostionsSuccess:returnValue];
        
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getDestiPostionsSuccess:(NSDictionary*)returnValue
{
    NSMutableArray* array=[[NSMutableArray alloc]initWithCapacity:0];
    array=returnValue[@"data"][@"postions"];
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        allModel* allm=[[allModel alloc]initWithDictionary:dic];
        [array1 addObject:allm];
    }
   // NSLog(@"yyyyyyyyy%d",array1.count);
    self.returnBlock(array1);
}
//搜索
-(void)modify:(NSString*)user_id withNick_name:(NSString*)nick_name withSex:(NSString*) sex withPhone:(NSString*)phone
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_register_user/updateUser"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"user_id\":\"%@\",",user_id];
    [paramjsonV appendFormat:@"\"nick_name\":\"%@\",",nick_name];
    [paramjsonV appendFormat:@"\"sex\":\"%@\",",sex];
    [paramjsonV appendFormat:@"\"phone\":\"%@\"",phone];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self modifySuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)modifySuccess:(NSDictionary*)returnValue
{
    NSString* string=returnValue[@"status"];
    self.returnBlock(string);
}
//意见反馈
-(void)feedback:(NSString*)user_id withContent:(NSString*)content withMobile:(NSString*)mobile
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_user/addFeedBack"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"user_id\":\"%@\",",user_id];
    [paramjsonV appendFormat:@"\"content\":\"%@\",",content];
    [paramjsonV appendFormat:@"\"mobile\":\"%@\"",mobile];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self feedbackSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)feedbackSuccess:(NSDictionary*)returnValue
{
    NSString* string=returnValue[@"status"];
    self.returnBlock(string);
}
//搜索活动目的地
-(void)searchActivity:(NSString*)key_word withUserId:(NSString*)user_id withLatitude:(double)latitude withLongtitude:(double)longtitude
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/searchActi"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"key_word\":\"%@\",",key_word];
    [paramjsonV appendFormat:@"\"user_id\":\"%@\",",user_id];
    [paramjsonV appendFormat:@"\"latitude\":\"%f\",",latitude];
    [paramjsonV appendFormat:@"\"longtitude\":\"%f\"",longtitude];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self searchACtivitySuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
}
-(void)searchACtivitySuccess:(NSDictionary*)returnValue
{
    NSArray* array=[[NSArray alloc]init];
    array=returnValue[@"data"][@"acti"];
    //NSLog(@"%@",array);
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        acModel* aModel=[[acModel alloc]initWithDictionanry:dic];
        [array1 addObject:aModel];
        
    }
     NSArray* array2=[[NSArray alloc]init];
    array2=returnValue[@"data"][@"destination"];
    for (NSDictionary* dic in array2) {
        deModel* dModel=[[deModel alloc]initWithDictionary:dic];
        [array1 addObject:dModel];
    }
    self.returnBlock(array1);
}
//获取最近三个月的数据
-(void)gettThreeMonthData:(NSString*)actiId withYear:(NSString*)year withMonth:(NSString*)month withNumber:(NSString*)number;
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getDatePrice"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\",",actiId];
    [paramjsonV appendFormat:@"\"year\":\"%@\",",year];
    [paramjsonV appendFormat:@"\"month\":\"%@\",",month];
    [paramjsonV appendFormat:@"\"num\":\"%@\"",number];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=====%@", returnValue);
        [self getThreeMonthDataSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];

}
-(void)getThreeMonthDataSuccess:(NSDictionary*)returnValue
{
    NSArray* array=returnValue[@"data"][@"dataPrice"];
    NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary* dic in array) {
        timeViewModel* timeModel=[[timeViewModel alloc]initWithDiconary:dic];
        [array1 addObject:timeModel];
    }
    self.returnBlock(array1);
}
//获得出发时间
-(void)getStartTime:(NSString*)actiId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/getStartTime"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"actiId\":\"%@\",",actiId];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        DDLog(@"=%@", returnValue);
        [self getStartTimeSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
    

}
-(void)getStartTimeSuccess:(NSDictionary*)returnValue
{
    NSMutableArray* array=[[NSMutableArray alloc]initWithCapacity:0];
    NSDictionary* dic=returnValue[@"data"][@"num"];
    maxModel* mModel=[[maxModel alloc]initWithDictionary:dic];
    [array addObject:mModel];
    NSMutableArray* array1=returnValue[@"data"][@"startTime"];
    [array addObjectsFromArray:array1];
    self.returnBlock(array);
}
//发送订单
-(void)commitOrderPage:(NSString*)price withRealName:(NSString*)realName withPhone:(NSString*)phone withStartDate:(NSString*)startDate withTime:(NSString*)time withTotal:(NSString*)total withNum:(NSString*)num withEmail:(NSString*)email withActiId:(NSString*)actiId withUseId:(NSString*)useId
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_order/postOrder"];
    //NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    NSDictionary* dic=@{@"price":price,@"realName":realName,@"phone":phone,@"startDate":startDate,@"time":time,@"total":total,@"num":num,@"email":email,@"actiId":actiId,@"userId":useId};
    [NetRequestClass  NetRequestPOSTWithRequestURL:url WithParameter:dic WithReturnValeuBlock:^(id returnValue) {
        NSLog(@"return==%@",returnValue);
        [self commitOrderSuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}
-(void)commitOrderSuccess:(NSDictionary*)returnValue
{
    NSMutableArray* array=[[NSMutableArray alloc]initWithCapacity:0];
    NSDictionary* dic=returnValue[@"data"][@"order"];
    NSString* orderId=[dic objectForKey:@"id"];
    [array addObject:orderId];
    self.returnBlock(array);
}
//向服务器发送请求获取charge
-(void)jumpPay:(NSString*)orderId withChannel:(NSString*)channel withClientIp:(NSString*)clientIp withCurrency:(NSString*)currency withFlag:(NSString*)flag
{
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_order/getCharge"];
    //NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    NSDictionary* dic=@{@"orderId":orderId,@"channel":channel,@"clientIp":clientIp,@"currency":currency,@"flag":flag};
    [NetRequestClass  NetRequestPOSTWithRequestURL:url WithParameter:dic WithReturnValeuBlock:^(id returnValue) {
        NSLog(@"return==%@",returnValue);
        [self jumpPaySuccess:returnValue];
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];

}
-(void)jumpPaySuccess:(NSDictionary*)returnValue
{
    self.returnBlock(returnValue);
}
#pragma 对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}
-(void)getAtitude:(NSString*)latitude withlongitude:(NSString*)longitude
{
    
}
#pragma 对网路异常进行处理
-(void) netFailure
{
   
    self.failureBlock();
}
@end





