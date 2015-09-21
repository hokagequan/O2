

#import "ViewModelClass.h"
#import "CenterModel.h"

@interface CenterViewModel : ViewModelClass
//获取围脖列表
-(void) fetchPublicWeiBo;

//跳转到微博详情页
///Users/tao/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/1904308824/Image/(UHT5W05Z1}[V)L(W$_D7@F.gif-(void) weiboDetailWithPublicModel: (CenterModel *) publicModel WithViewController: (UIViewController *)superController;
@end
