//
//  setDataViewController.m
//  O2Trip
//
//  Created by tao on 15/9/8.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "setDataViewController.h"
#import "orderViewController.h"

#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface setDataViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    int _keyHeight;
    UITextField* _textField;
    UILabel* _bgLabel;
    UIView* _moView;
    UIView* _bgView;
    UIPickerView* _pickerView;
    NSArray* _array;
    int _lastHeight;
}
@end

@implementation setDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShowView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.actiLabel.text=self.actiName;
    self.actiTimeLabel.text=self.actiTime;
    self.numbelLabel.text=[NSString stringWithFormat:@"%@×成人",self.peopleNumber];
    self.priceLabel.text=self.bigPriceString;
    _array=[NSArray arrayWithObjects:@"先生",@"小姐",@"女士",nil];
    // Do any additional setup after loading the view.
}

//当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [_textField removeFromSuperview];
    [_bgLabel removeFromSuperview];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _textField.frame= CGRectMake(16, self.view.frame.size.height-height-30, self.view.frame.size.width-32, 30);
     _bgLabel.frame=CGRectMake(0, self.view.frame.size.height-height-34, self.view.frame.size.width, 38);
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==5) {
        textField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
      if ([string isEqualToString:@"\n"]) {
        
        if (textField.text.length==0) {
            ALERTVIEW(@"输入为空");
        }else
        {
             if (textField.tag==1) {
                self.appellationLabel.text=textField.text;
                
            }else if (textField.tag==2)
            {
                
                self.nameLabel.text=textField.text;
            }else if (textField.tag==3)
            {
                
                self.surnamesLabel.text=textField.text;
            }else if (textField.tag==4)
            {
               
                if ([self validateEmail:textField.text]) {
                    self.emailLabel.text=textField.text;
                }else
                {
                    ALERTVIEW(@"请输入正确的邮箱号");
                }
                
            }else if (textField.tag==5)
            {
                
                if ([self isMobileNumber:textField.text]) {
                     self.phoneLabel.text=textField.text;
                }else{
                    ALERTVIEW(@"请输入正确的手机号");
                }
               
            }
        }
           [textField resignFirstResponder];
          [_bgLabel removeFromSuperview];
    }
    return YES;
}
- (IBAction)setUpMsgButtonClick:(id)sender
{
    [_textField removeFromSuperview];
    UIButton*button=(UIButton*)sender;
    [self performSelector:@selector(setTextField:) withObject:button afterDelay:0.2];
   
    
}
-(void)setTextField:(UIButton*)button
{
    if (button.tag==1)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        _moView.alpha=0.3;
        _bgView.frame=CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);
        [UIView commitAnimations];
         self.niChengString=[_array objectAtIndex:0];
    }
    else
    {
        if (_lastHeight==0)
        {
            if (button.tag==5) {
                _lastHeight=216;
            }else
            {
                _lastHeight=256;
            }
        }
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(16, self.view.frame.size.height-_lastHeight-30, self.view.frame.size.width-32, 30)];
        _textField.borderStyle=UITextBorderStyleRoundedRect;
        _textField.delegate=self;
        _textField.tag=button.tag;
        _textField.returnKeyType= UIReturnKeyDone;
        _bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-_lastHeight-34, self.view.frame.size.width, 38)];
        _bgLabel.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self.view addSubview:_bgLabel];
        [self.view addSubview:_textField];
        [_textField becomeFirstResponder];

    }
    
    
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//判断是否为邮箱
-(BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:email]==YES) {
        return YES;
    }else
    {
        return NO;
    }
   
}
//判断是否为电话号码
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionButtonClick:(id)sender
{
    if (self.appellationLabel.text.length==0||self.appellationLabel.text.length==0||self.surnamesLabel.text.length==0||self.emailLabel.text.length==0||self.phoneLabel.text.length==0) {
        ALERTVIEW(@"请将数据填完整");
    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        orderViewController* orderVc=[SB instantiateViewControllerWithIdentifier:@"orderViewController"];
        orderVc.actiName=self.actiName;
        orderVc.actiTime=self.actiTime;
        orderVc.actiPrice=self.bigPriceString;
        orderVc.peopleNumber=self.peopleNumber;
        orderVc.smallPrice=self.priceString;
        orderVc.contactPeople=[NSString stringWithFormat:@"%@%@",self.surnamesLabel.text,self.nameLabel.text];
        orderVc.phone=self.phoneLabel.text;
        orderVc.email=self.emailLabel.text;
        
        [self.navigationController pushViewController:orderVc animated:YES];
    }
}
//创建弹出的试图
-(void)setShowView
{
    _moView=[[UIView alloc]initWithFrame:self.view.frame];
    _moView.backgroundColor=[UIColor blackColor];
    _moView.alpha=0;
    [self.view addSubview:_moView];
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 1500, self.view.frame.size.width,self.view.frame.size.height-271)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgView];
    UILabel* bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, 45)];
    bgLabel.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_bgView addSubview:bgLabel];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-(60*2), 45)];
    label.text=@"请选择称谓";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:11];
    label.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_bgView addSubview:label];
    UIButton* finishzButton=[UIButton buttonWithType:UIButtonTypeCustom];
    finishzButton.frame=CGRectMake(_bgView.frame.size.width-60, 0,60, 45);
    [finishzButton setTitle:@"确定" forState:UIControlStateNormal];
    finishzButton.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:13];
    [finishzButton setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
    [finishzButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:finishzButton];
    _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 162)];
    //注意：如果你想让pickView现实数据，一定要设置数据源协议
    _pickerView.dataSource = self;
    //注意：如果你想使用pickView的代理方法，一定要设置delegate
    _pickerView.delegate = self;
    //现实选中框
    [ _pickerView showsSelectionIndicator];
    //选中第几列的第几行
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [_bgView addSubview:  _pickerView];
   
    
    
}


//确定选择性别
-(void)finishButtonClick:(UIButton*)button
{
    self.appellationLabel.text=self.niChengString;
    _moView.alpha=0;
    _bgView.frame=CGRectMake(1, 10000, 20, 20);
}
#pragma mark   ----UIPickerViewDataSource----
//设置pickerView现实几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //列
    return 1;
}
//设置每列可以现实的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //行
    
    //设置第0列的行数
    
    return _array.count;
    
}
//每列现实的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* string=[_array objectAtIndex:row];
    return string;
    
    
}
//点击选择row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    self.niChengString=[_array objectAtIndex:row];
    
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
