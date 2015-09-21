
//  UserModel.h

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

//@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *loginUserId;
@property(nonatomic,strong)NSString* status;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *passWord;
@property (strong, nonatomic) NSString *userName;
@property(nonatomic,strong)NSString* key;
@property(nonatomic,strong)NSString* registerDate;
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* image;
@property(nonatomic,strong)NSString* sex;
//@property (strong, nonatomic) NSString *email;
//@property (strong, nonatomic) NSString *phone;
//@property (strong, nonatomic) NSURL *imageUrl;
//@property (strong, nonatomic) NSString *sex;

@end
