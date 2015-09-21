//
//  contactViewController.m
//  O2Trip
//
//  Created by tao on 15/8/7.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "contactViewController.h"
#import <MessageUI/MessageUI.h>
#import "webViewController.h"
@interface contactViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation contactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)emailButtonClick:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        //设置邮件代理
        picker.mailComposeDelegate=self;
        
        //设置主题
        [picker setSubject:@"Hello from O2trip!"];
        
        //收件人 可以设置一组
        NSArray *toRecipients = [NSArray arrayWithObject:@"info@o2trip.cn"];
        //cc (Carbon Copy)抄送 数组
//        NSArray *ccRecipients = [NSArray arrayWithObjects:@"123@qq.com", @"456@qq.com", nil];
//        //秘密抄送 即密送(bland Carbon Copy)
//        NSArray *bccRecipients = [NSArray arrayWithObject:@"123456@qq.com"];
        
        [picker setToRecipients:toRecipients];
//        [picker setCcRecipients:ccRecipients];
//        [picker setBccRecipients:bccRecipients];
        
        //添加一个附件图片给邮件
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//        NSData *myData = [NSData dataWithContentsOfFile:path];
        //以data的形式添加
//        [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
        
        //图片第二种加载方式 html
       // NSString *emailBody = @"<a href=http://www.baidu.com>有用的提示</a> <img src=http://www.baidu.com/img/bdlogo.gif width=120 height=129 />";
        
        //        NSString *emailBody = @"很感谢你能来到中国";
        //设置消息主体  正文 如果加载的是普通字符串 第二个参数为NO 如果是HTML 为YES
        //        [picker setMessageBody:emailBody isHTML:YES];
        //弹出。。。
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        //设备没有配置邮件账户 提示用户配置
        //NSLog(@"Device not configured to send mail.");
    }
}
#pragma mark - Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
           // NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Result: Mail sending failed");
            break;
        default:
            //NSLog(@"Result: Mail not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)phoneButtonClick:(id)sender
{
     NSURL *phoneUrl = [NSURL URLWithString:@"tel://400-004-0510"];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURLRequest *request = [NSURLRequest requestWithURL:phoneUrl];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

- (IBAction)appStoreButtonClick:(id)sender
{
    
    
    
    
    
}
- (IBAction)guanButtonClick:(id)sender
{
    webViewController* web=[[webViewController alloc]init];
    [self.navigationController pushViewController:web animated:YES];
}
- (void)didReceiveMemoryWarning
{
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
