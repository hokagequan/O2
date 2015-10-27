//
//  myDataViewController.m
//  O2Trip
//
//  Created by tao on 15/8/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "myDataViewController.h"
#import "AFNetworking.h"
#import "UserViewModel.h"
#import "UIImageView+WebCache.h"
#import "GiFHUD.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface myDataViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIView* _smallView;
    UIView* _bigView;
    UILabel* _titleLabel;
    UILabel* _tipeLabel;
    UITextField* _textField;
    UIActionSheet *_actionSheet;
}
@end

@implementation myDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = NO;
    self.title = @"个人资料";
    
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* nickName=[userDefaults objectForKey:@"nickName"];
    NSString* sex=[userDefaults objectForKey:@"sex"];
    NSString* imageUrl=[userDefaults objectForKey:@"imageUrl"];
    NSString* phone=[userDefaults objectForKey:@"phone"];
    if ([sex isEqualToString:@"1"]) {
        sex=@"男";
    }else if ([sex isEqualToString:@"2"])
    {
        sex=@"女";
    }else
    {
        sex=@"未知";
    }
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,imageUrl]];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=39.5;
    [self.headImage sd_setImageWithURL:url];
    self.nickNameLabel.text=nickName;
    self.sexLabel.text=sex;
    self.phoneLabe.text=phone;
   

    // Do any additional setup after loading the view.
    
}
- (IBAction)upheadButtonClick:(id)sender
{
  
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [_actionSheet addButtonWithTitle:@"拍照"];
    [_actionSheet addButtonWithTitle:@"从手机相册选择"];
    // 同时添加一个取消按钮
    [_actionSheet addButtonWithTitle:@"取消"];
    // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮
    _actionSheet.destructiveButtonIndex = _actionSheet.numberOfButtons - 1;
    [_actionSheet showInView:self.view];
    
}

//当选择一张图片后进入这里
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (buttonIndex == 0)//照相机
    {
        if ([self isCameraAvailable]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }else
        {
            ALERTVIEW(@"照相机不能用");
        }
    }
    if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    if (buttonIndex == 2)
    {
        
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    NSData * imageData=UIImagePNGRepresentation(image);
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //上传图片等用这个方法
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
    NSString* url=@"http://test.o2lx.com:8080/trip/ws/rest_user/uploadPortrait";

//    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
//    [paramjsonV appendFormat:@"{"];
//    [paramjsonV appendFormat:@"\"user_id\":\"%@\",",user_id];
//    [paramjsonV appendFormat:@"\"uploaded_file\":\"%@\"",@"head"];
//    [paramjsonV appendFormat:@"}"];
//    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    //NSLog(@"url====%@",parameter);
    NSDictionary* dic=@{@"user_id":user_id};
   // NSLog(@"-=-=%@",dic);
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileData:@"二进制数据" name:@"参数名" fileName:@"文件名" mimeType:@"上传的类型"];
        [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:@"headImage.png" mimeType:@"jpg/png"];
        
       // NSLog(@"-=-=%@",formData);
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"上传成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString* status =[dic objectForKey:@"status"];
        NSString* imageUrl=[dic objectForKey:@"image_url"];
       
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,imageUrl]];
        [self.headImage sd_setImageWithURL:url];
        NSUserDefaults* userDefaults =[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:imageUrl forKey:@"imageUrl"];
        [userDefaults synchronize];
        if ([status isEqualToString:@"1"]) {
            ALERTVIEW(@"上传成功");
            [GiFHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
      [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeNameButtonClick:(id)sender
{
    [self setUpView:1];
}

- (IBAction)chengeSexButtonClick:(id)sender
{
    [self setSex];
}

- (IBAction)BindingphoneButtonClick:(id)sender
{
    [self setUpView:2];
    _titleLabel.text=@"绑定手机";
    _tipeLabel.alpha=0;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
}

- (IBAction)backButtonClick:(id)sender
{
    [GiFHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUpView:(int)tag
{
    _bigView=[[UIView alloc]initWithFrame:self.view.frame];
    _bigView.backgroundColor=[UIColor blackColor];
    _bigView.alpha=0.3;
    [self.view addSubview:_bigView];
    _smallView=[[UIView alloc]initWithFrame:CGRectMake(40, (self.view.frame.size.height-160)/1.9, self.view.frame.size.width-80, 160)];
    _smallView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    _smallView.layer.masksToBounds=YES;
    //smallView.layer.borderWidth=1.0;
    _smallView.layer.cornerRadius=5.0;
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 85, 30)];
    _titleLabel.text=@"昵称设置";
    _titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
    _titleLabel.textColor=[UIColor blackColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [_smallView addSubview:_titleLabel];
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-100, 40)];
    _textField.backgroundColor=[UIColor whiteColor];
    _textField.borderStyle=UITextBorderStyleNone;
    _textField.placeholder=@"输入框";
    _textField.delegate=self;
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    _textField.returnKeyType= UIReturnKeyDone;
    [_smallView addSubview:_textField];
    UIButton* cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _tipeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 90,self.view.frame.size.width-80, 20)];
    _tipeLabel.text=@"给自己起一个独一无二的名字吧~";
    _tipeLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:8.5];;
    _tipeLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [_smallView addSubview:_tipeLabel];
    cancelButton.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:13];
    [cancelButton setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.frame=CGRectMake(0, 115, _smallView.frame.size.width/2, 45);
    cancelButton.layer.borderWidth=0.5;
    [cancelButton addTarget:self action:@selector(cancelbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.5, 0.3, 0.3, 0.1 });
    cancelButton.layer.borderColor =borderColorRef;
    [_smallView addSubview:cancelButton];
    UIButton* sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame=CGRectMake(_smallView.frame.size.width/2, 115, _smallView.frame.size.width/2, 45);
    sureButton.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    sureButton.layer.borderWidth=0.5;
    sureButton.layer.borderColor =borderColorRef;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:13];
    sureButton.tag=tag;
     [sureButton setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_smallView addSubview:sureButton];
    [self.view addSubview:_smallView];
    CGColorSpaceRelease(colorSpace);
}
-(void)setSex
{
    _bigView=[[UIView alloc]initWithFrame:self.view.frame];
    _bigView.backgroundColor=[UIColor blackColor];
    _bigView.alpha=0.3;
    [self.view addSubview:_bigView];
    _smallView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width, 160)];
    _smallView.backgroundColor=[UIColor  colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_smallView];
    UIButton* button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(0, 0, self.view.frame.size.width, 38);
    [button1 setTitle:@"性别修改" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont systemFontOfSize:14];
    [button1 setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    button1.backgroundColor=[UIColor whiteColor];
    [_smallView addSubview:button1];
    UIButton* button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(0, 40, self.view.frame.size.width, 38);
    [button2 setTitle:@"男" forState:UIControlStateNormal];
    button2.tag=1;
    button2.titleLabel.font=[UIFont systemFontOfSize:16];
     [button2 setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor whiteColor];
     [button2 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_smallView addSubview:button2];
    UIButton* button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(0, 80, self.view.frame.size.width, 38);
    [button3 setTitle:@"女" forState:UIControlStateNormal];
    button3.tag=2;
    button3.titleLabel.font=[UIFont systemFontOfSize:16];
    [button3 setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    button3.backgroundColor=[UIColor whiteColor];
     [button3 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_smallView addSubview:button3];
    UIButton* button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(0, 120, self.view.frame.size.width, 38);
    [button4 setTitle:@"取消" forState:UIControlStateNormal];
    button4.titleLabel.font=[UIFont systemFontOfSize:16];
    [button4 setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(button4Click:) forControlEvents:UIControlEventTouchUpInside];
    button4.backgroundColor=[UIColor whiteColor];
    [_smallView addSubview:button4];

    
}
//性别修改
-(void)button1Click:(UIButton*)button
{
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
    NSString*sex=[NSString stringWithFormat:@"%ld",button.tag];
    [userModel modify:user_id withNick_name:@"" withSex:sex withPhone:@""];
    [_bigView removeFromSuperview];
    [_smallView removeFromSuperview];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        if ([returnValue isEqualToString:@"1"]) {
            UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            self.sexLabel.text=button.titleLabel.text;
            NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSString stringWithFormat:@"%ld",button.tag] forKey:@"sex"];
             [userDefaults synchronize];
        }
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];

}
//取消修改
-(void)cancelbuttonClick:(UIButton*)button
{
    button.backgroundColor= [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_bigView removeFromSuperview];
    [_smallView removeFromSuperview];
}
//确认修改昵称和绑定手机
-(void)sureButtonClick:(UIButton*)button
{
    [_bigView removeFromSuperview];
    [_smallView removeFromSuperview];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
    if (button.tag==1) {
        if (_textField.text.length==0) {
            ALERTVIEW(@"昵称不能为空");
        }else
        {
             [userModel modify:user_id withNick_name:_textField.text withSex:@"" withPhone:@""];
        }
        
    
    }else
    {
        if ([self isMobileNumber:_textField.text])
        {
            [userModel modify:user_id withNick_name:@"" withSex:@"" withPhone:_textField.text];
        }else
        {
            ALERTVIEW(@"请输入正确的手机号");
        }
        
    }
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        if ([returnValue isEqualToString:@"1"]) {
            UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            if (button.tag==1) {
                self.nickNameLabel.text=_textField.text;
                NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_textField.text forKey:@"nickName"];
                 [userDefaults synchronize];
                
            }else
            {
                 self.phoneLabe.text=_textField.text;
                NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_textField.text forKey:@"phone"];
                [userDefaults synchronize];
            }
            
           
        }
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
   
}
//判断是否为手机号
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[6-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     if ([string isEqualToString:@"\n"])
    {
         [textField resignFirstResponder];
    }
    return YES;
}
-(void)button4Click:(UIButton*)button
{
    [_smallView removeFromSuperview];
    [_bigView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
