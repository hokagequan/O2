//
//  feedbackViewController.m
//  O2Trip
//
//  Created by tao on 15/8/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "feedbackViewController.h"
#import "UserViewModel.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface feedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    BOOL istextField;
    UITextField* _textField;
    UILabel* _BgLabel;
}
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.backLabel.layer.borderWidth=0.5;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.5, 0.5, 0.5, 0.5 });
    self.backLabel.layer.borderColor=borderColorRef;
    self.mytextView.delegate=self;
    self.feedTextField.delegate=self;
    CGColorSpaceRelease(colorSpace);
    _BgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 1000, 0, 0)];
    _BgLabel.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_BgLabel];
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 1000, 0, 0)];
    _textField.placeholder=@"请输入你的手机号";
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    _textField.delegate=self;
    _textField.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_textField];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    istextField=YES;
  
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    istextField=NO;
    textView.text=nil;
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交意见反馈
- (IBAction)submitButtonClick:(id)sender
{
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
    if (self.mytextView.text.length==0) {
        ALERTVIEW(@"请输入评论内容");
    }else if([self isMobileNumber:self.feedTextField.text]) {
       [userModel feedback:user_id withContent:self.mytextView.text withMobile:self.feedTextField.text];
       [userModel setBlockWithReturnBlock:^(id returnValue) {
           if ([returnValue isEqualToString:@"1"]) {
               UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
           }
       } WithErrorBlock:^(id errorCode) {
           
       } WithFailureBlock:^{
           
       }];
    }else
    {
        ALERTVIEW(@"请输入正确的手机号");
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
    }
    
}
//延时消失
-(void)dismissAlertView:(UIAlertView*)alertView
{
    if (alertView != nil)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
    }

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
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"%d",height);
    if (istextField==YES) {
        self.feedTextField.alpha=0;
        _textField.alpha=1;
        _BgLabel.alpha=1;
        _textField.frame=CGRectMake((self.view.frame.size.width-288)/2,self.view.frame.size.height-height-30, 288, 30);
        _BgLabel.frame=CGRectMake(0, self.view.frame.size.height-height-34, self.view.frame.size.width, 38);
        self.label.alpha=0;
        [_textField becomeFirstResponder];
    }
  
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.label.alpha=1;
    self.bgLabel.alpha=0;
    self.feedTextField.alpha=1;
    _textField.alpha=0;
    _BgLabel.alpha=0;
    self.feedTextField.text=_textField.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
