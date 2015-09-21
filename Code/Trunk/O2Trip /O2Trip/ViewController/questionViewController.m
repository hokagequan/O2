//
//  questionViewController.m
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "questionViewController.h"
#import "Reachability.h"
#import "GiFHUD.h"
#import "UserViewModel.h"
#import "questionCell.h"
#import "probleModel.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@implementation questionViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [GiFHUD setGifWithImageName:@"ajax-loader-big.gif"];
    [GiFHUD show];
   
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.lanrenios.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self performSelector:@selector(showAlertView) withObject:nil afterDelay:4.0f];
        });
    };
    
    [reach startNotifier];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    UserViewModel* viewModel=[[UserViewModel alloc]init];
    [viewModel getprogram:useId withPage:@"1" withNum:@"20"];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.array=returnValue;
        
        [self.tabelView reloadData];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];

}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        
    }
    else
    {
        
    }
}
-(void)showAlertView
{
  
    ALERTVIEW(@"为啥老是跳");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    questionCell* cell=[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"questionCell" owner:self options:nil]lastObject];
    }
    probleModel* proModel=[self.array objectAtIndex:indexPath.row];
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",proModel.actiPrice];
    cell.titleLabel.text=proModel.userName;
    cell.textlabel.text=proModel.problemContent;
    cell.dataLabel.text=proModel.problemDate;
    cell.titleLable1.text=@"氧气旅行客服回复:";
    if ([proModel.status isEqualToString:@"false"]) {
        cell.textlabel1.text=@"暂未回复";
        cell.dateLabel.hidden=YES;
    }else
    {
        NSDictionary* dic=[proModel.replyArray lastObject];
        cell.textlabel1.text=[dic objectForKey:@"replyContent"];
        cell.dateLabel.text=[dic objectForKey:@"replyDate"];
    }
    return cell;
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
