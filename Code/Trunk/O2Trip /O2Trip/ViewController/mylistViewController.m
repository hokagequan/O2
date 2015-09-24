//
//  mylistViewController.m
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "mylistViewController.h"
#import "reviewViewController.h"
#import "collectionViewController.h"
#import "LoginViewController.h"
#import "UserViewModel.h"
#import "UserModel.h"
#import "questionViewController.h"
#import "mylistCell.h"
#import "mylistCell2.h"
#import "bigMapViewController.h"
#import "SetUpTheViewController.h"
#import "myDataViewController.h"
#import "collectionViewController.h"
#import "middleViewController.h"
#import "GiFHUD.h"
#import "UIImageView+WebCache.h"

typedef enum {
    MyListRowsInformation = 0,
    MyListRowsShoppingCart,
    MyListRowsOrders,
    MyListRowsContacts,
    MyListRowsFavorates,
    MyListRowsMax
}MyListRows;

@implementation mylistViewController
{
    mylistCell2* _cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.tableView reloadData];
    

}

-(void)viewDidLoad
{

    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    [self performSelector:@selector(showjuhua) withObject:nil afterDelay:0.1f];
     self.navigationController.navigationBarHidden=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(void)showjuhua
{
    [GiFHUD dismiss];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return MyListRowsMax;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 135;
  
    }else
    {
        return 44.0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        mylistCell* cell=[tableView dequeueReusableCellWithIdentifier:@"mylistcell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"mylistCell" owner:self options:nil]lastObject];
        }
        NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
        NSString* imageUrl=[userDefaults objectForKey:@"imageUrl"];
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,imageUrl]];
        cell.headImage.layer.masksToBounds=YES;
        cell.headImage.layer.cornerRadius=31.5;
        [cell.headImage sd_setImageWithURL:url];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSString* userId=[userDefaults objectForKey:@"account"];
        NSString* registerDate=[userDefaults objectForKey:@"registerDate"];
        NSString* nickName=[userDefaults objectForKey:@"nickName"];
        NSString* sex=[userDefaults objectForKey:@"sex"];
        if ([sex isEqualToString:@"1"]) {
            sex=@"男";
        }else if ([sex isEqualToString:@"2"])
        {
            sex=@"女";
        }else
        {
            sex=@"未知";
        }
        if (nickName.length!=0) {
            [cell.loginButton setTitle:nickName forState:UIControlStateNormal];
            cell.loginButton.userInteractionEnabled=NO;
        }else if (userId.length!=0)
        {
            [cell.loginButton setTitle:userId forState:UIControlStateNormal];
             cell.loginButton.userInteractionEnabled=NO;
        }else
        {
            cell.loginButton.userInteractionEnabled=YES;
            [cell.loginButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
            [cell.loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (registerDate.length!=0) {
            if (sex.length==0) {
                sex=@"未知";
            }
            cell.introlductionLabel.text=[NSString stringWithFormat:@"%@  %@加入",sex,registerDate];
        }else
        {
            cell.introlductionLabel.text=@"这里为你开启了一扇新世界的大门";
        }
        cell.swichImageButton.userInteractionEnabled=YES;
        [cell.swichImageButton addTarget:self action:@selector(swichImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
                return cell;
        
    }else
    {
//        _cell=[tableView dequeueReusableCellWithIdentifier:@"mylistcell2"];
//        if (_cell==nil) {
//            _cell=[[[NSBundle mainBundle]loadNibNamed:@"mylistCell2" owner:self options:nil]lastObject];
//        }
//        _cell.mydataBgLabel.backgroundColor=[UIColor whiteColor];
//        _cell.collectBglabel.backgroundColor=[UIColor whiteColor];
//        _cell.jiantouImage.image=[UIImage imageNamed:@"mine@3x-08.png"];
//        _cell.jiantouImage2.image=[UIImage imageNamed:@"mine@3x-08.png"];
//        _cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        [_cell.myDataButton addTarget:self action:@selector(myDataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_cell.collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        return _cell;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case MyListRowsInformation:
                cell.imageView.image = [UIImage imageNamed:@"mine@3x-04.png"];
                cell.textLabel.text = @"个人资料";
                cell.detailTextLabel.text = @"";
                break;
            case MyListRowsFavorates:
                cell.imageView.image = [UIImage imageNamed:@"mine@3x-05.png"];
                cell.textLabel.text = @"收藏列表";
                cell.detailTextLabel.text = @"";
                break;
            case MyListRowsShoppingCart:
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.textLabel.text = @"购物车";
                cell.detailTextLabel.text = @"";
                break;
            case MyListRowsOrders:
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.textLabel.text = @"订单中心";
                cell.detailTextLabel.text = @"";
                break;
            case MyListRowsContacts:
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.textLabel.text = @"联系人";
                cell.detailTextLabel.text = @"";
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}
//修改头像
-(void)swichImageButtonClick
{
    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
    NSString* userId=[userDefaults objectForKey:@"account"];
    if (userId.length!=0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDataViewController* setVc=[SB instantiateViewControllerWithIdentifier:@"myDataViewController"];
        [self.navigationController pushViewController:setVc animated:YES];
    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* loginVc=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:loginVc animated:YES];

    }
  
}
-(void)myDataButtonClick:(UIButton*)button
{
    _cell.mydataBgLabel.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    _cell.jiantouImage.image=[UIImage imageNamed:@"mine@3x-06.png"];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* userId=[userDefaults objectForKey:@"account"];
    if (userId.length!=0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myDataViewController* loginVc=[SB instantiateViewControllerWithIdentifier:@"myDataViewController"];
        NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:1];
        mylistCell2* cell=(mylistCell2*)[self.tableView  cellForRowAtIndexPath:indexpath];
        cell.jiantouImage.image=[UIImage imageNamed:@"mine@3x-08.png"];
        [self.navigationController pushViewController:loginVc animated:YES];
    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* loginVc=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    

}
//点击cell跳转登陆
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"account"];
    if (useId.length!=0) {
        switch (indexPath.row) {
            case MyListRowsInformation:
                [self myDataButtonClick:nil];
                break;
            case MyListRowsFavorates:
                [self collectButtonClick:nil];
                break;
            case MyListRowsShoppingCart:
                [self performSegueWithIdentifier:@"ShoppingCartSegue" sender:self];
                break;
            case MyListRowsOrders:
                [self performSegueWithIdentifier:@"OrdersSegue" sender:self];
                break;
            case MyListRowsContacts:
                [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
                break;
                
            default:
                break;
        }
    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* loginVc=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:loginVc animated:YES];
        

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
-(void)collectButtonClick:(UIButton*)button
{
    _cell.collectBglabel.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    _cell.jiantouImage2.image=[UIImage imageNamed:@"mine@3x-06.png"];
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    collectionViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"collectionViewController"];
    NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:1];
    mylistCell2* cell=(mylistCell2*)[self.tableView  cellForRowAtIndexPath:indexpath];
    cell.jiantouImage2.image=[UIImage imageNamed:@"mine@3x-08.png"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)loginButtonClick:(UIButton*)button
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    middleViewController* loginVc=[SB instantiateViewControllerWithIdentifier:@"middleViewController"];
    [self.navigationController pushViewController:loginVc animated:YES];
    
}
-(void)remarkButtonClick:(UIButton*)button
{
   
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    [userModel getDiscusses:useId setPage:@"1" setNum:@"3"];
     [userModel setBlockWithReturnBlock:^(id returnValue) {
         UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
         reviewViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"reviewViewController"];
         detailVC.array=returnValue;
         [self.navigationController pushViewController:detailVC animated:YES];
     } WithErrorBlock:^(id errorCode) {
         
     } WithFailureBlock:^{
         
     }];
    
}
-(void)askButtonButtonClick:(UIButton*)button
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    questionViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"questionViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)collectionButtonClick:(UIButton*)button
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    collectionViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"collectionViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)setButtonClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetUpTheViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"SetUpTheViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
