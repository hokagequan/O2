

#import "ViewModelClass.h"
#import "UserModel.h"

@interface UserViewModel : ViewModelClass

-(void) login:(NSString *) userName setPassWord :(NSString *) passWord;
-(void) register:(NSString *) email setPassWord :(NSString *) passWord;
-(void)exitLogin:(NSString*)key;
-(void)getDetailDestination:(NSString*)countryName withlatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId;
-(void)getCollection:(NSString*)userID setPage:(NSString*)page setNum:(NSString*)num;
-(void)getActivity;
-(void)getdetailActivity:(NSString*)actiType withlatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId;
-(void)getdestination:(NSString*)countryName withLatitude:(double)latitude withLongtitude:(double)longitude withUseId:(NSString*)useId;
-(void)cancelCollection:(NSString*)userId withactiId:(NSString*)actiId;
-(void)clippraise:(NSString*)userId withactiId:(NSString*)actiId;
-(void)getDiscusses:(NSString*)actiId setPage:(NSString*)page setNum:(NSString*)num;
-(void)getcollectionDetail:(NSString*)actiId;
-(void) homeXQ:(NSString *) actiId withUserId:(NSString*)useId;
-(void)addCollect:(NSString*)loginUserId withactiId:(NSString*)actiId;
-(void)clipprais:(NSString *)userId withactiId:(NSString *)actiId;
-(void)getAtitude:(NSString*)latitude withlongitude:(NSString*)longitude;
-(void)adddiscum:(NSString*)loginUesrId withActiId:(NSString*)actiId withLevel:(NSString*)level withcontext:(NSString*)context;
-(void)addProblem:(NSString*)loginUserId withprogramContent:(NSString*)programContent withActiId:(NSString*)actiId;
-(void)getprogram:(NSString*)userId withPage:(NSString*)page withNum:(NSString*)num;
-(void)getgetDestiPostions;
-(void)searchActivity:(NSString*)key_word withUserId:(NSString*)user_id withLatitude:(double)latitude withLongtitude:(double)longtitude;
-(void)modify:(NSString*)user_id withNick_name:(NSString*)nick_name withSex:(NSString*) sex withPhone:(NSString*)phone;
-(void)feedback:(NSString*)user_id withContent:(NSString*)content withMobile:(NSString*)mobile;
-(void)gettThreeMonthData:(NSString*)actiId withYear:(NSString*)year withMonth:(NSString*)month withNumber:(NSString*)number;
-(void)getStartTime:(NSString*)actiId;
-(void)commitOrderPage:(NSString*)price withRealName:(NSString*)realName withPhone:(NSString*)phone withStartDate:(NSString*)startDate withTime:(NSString*)time withTotal:(NSString*)total withNum:(NSString*)num withEmail:(NSString*)email withActiId:(NSString*)actiId withUseId:(NSString*)useId;
-(void)jumpPay:(NSString*)orderId withChannel:(NSString*)channel withClientIp:(NSString*)clientIp withCurrency:(NSString*)currency withFlag:(NSString*)flag;
@end