//
//  collectionViewController.m
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "collectionViewController.h"

#import "UserViewModel.h"
#import "UIImageView+WebCache.h"
#import "collectionModel.h"
#import "UserViewModel.h"
#import "cancelModel.h"
#import "detailactivityViewController.h"
#import "GiFHUD.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "SVPullToRefresh.h"

#import "O2Trip-Swift.h"

#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface collectionViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottomLC;

@property (strong, nonatomic) NSMutableIndexSet *selectIndexes;

-(void)reachabilityChanged:(NSNotification*)note;

@end
@implementation collectionViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    UserViewModel* viewModel=[[UserViewModel alloc]init];
    [viewModel getCollection:useId setPage:@"1" setNum:@"10"];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.array=returnValue;
        [GiFHUD dismiss];
        [self collectionView];
        [self.tableView reloadData];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
  }

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.toolBottomLC.constant = -49;
    
    self.cellArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor grayColor];
    [self performSelector:@selector(showjuhua) withObject:nil afterDelay:0.1f];
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBarHidden=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.bianji addTarget:self action:@selector(bianjiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   [self.tableView addPullToRefreshWithActionHandler:^{
       NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
       NSString* useId=[userDefaults objectForKey:@"loginUserId"];
       UserViewModel* viewModel=[[UserViewModel alloc]init];
       [viewModel getCollection:useId setPage:@"1" setNum:@"10"];
       [viewModel setBlockWithReturnBlock:^(id returnValue) {
           self.array=returnValue;
           [GiFHUD dismiss];
           [self collectionView];
           [_tableView.pullToRefreshView stopAnimating];
           _tableView.showsInfiniteScrolling = YES;
           [self.tableView reloadData];
       } WithErrorBlock:^(id errorCode) {
           
       } WithFailureBlock:^{
           
       }];

   }];

}
//创建没有收藏的收藏界面
-(void)collectionView
{
    if (self.array.count==0) {
        UIImageView* bg=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-54)/2, 195, 54, 54)];
        bg.image=[UIImage imageNamed:@"collect@3x-02.png"];
        [self.view addSubview:bg];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 270, 150, 16)];
        label.font=[UIFont systemFontOfSize:13];
        label.text=@"从这里去探索全世界吧~";
        label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.view addSubview:label];
    }
    

}
-(void)bianjiButtonClick:(UIButton*)button
{
    isNil=!isNil;
    if (isclip==NO) {
        [button setTitle:@"取消" forState:UIControlStateNormal];
        isEdting=YES;
        isclip=YES;
        
        [self showToolBar:YES];
        
    }else
    {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        for (collectionCell* cell in self.cellArray) {
            cell.cancelLabel.alpha=0;
            cell.bgView.alpha=0;
            cell.cancelButton.alpha=0;
        }
        _cell.bgView.userInteractionEnabled=YES;
        isEdting=NO;
        isclip=NO;
        
        [self showToolBar:NO];
    }
    
    [self.tableView reloadData];

}

-(void)showjuhua
{
   [GiFHUD dismiss];
}

- (void)showToolBar:(BOOL)show {
    CGFloat distance = show ? 0 : -49;
    self.toolBottomLC.constant = distance;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 246;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    if (_cell==nil) {
        _cell=[[[NSBundle mainBundle]loadNibNamed:@"collectionCell" owner:self options:nil]lastObject];
    }
    CAGradientLayer* layer=[CAGradientLayer layer];
    layer.frame=CGRectMake(0,0, _cell.bgLabel.frame.size.width, _cell.bgLabel.frame.size.height);
    layer.colors=[NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor, nil];
    [_cell.bgLabel.layer insertSublayer:layer atIndex:0];
     _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    collectionModel* collectModel=[self.array objectAtIndex:indexPath.row];
    _cell.distanseLabel.text=collectModel.actiTitle;
    _cell.moneyLabel.text=[NSString stringWithFormat:@"￥%@",collectModel.price];
    if ([collectModel.tripDistance isEqualToString:@""]) {
         collectModel.tripDistance=@"暂无";
    }
    _cell.typeLabel.text=[NSString stringWithFormat:@"%@,%@KM",collectModel.type,collectModel.tripDistance];
    _cell.collectNumLabel.text=collectModel.praiseNum;
    _cell.timeLabel.text=collectModel.days;
    if ([collectModel.hasPraise isEqualToString:@"true"]) {
        [_cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
    }
    [_cell.collectionButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cell.collectionButton.tag=indexPath.row;
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[collectModel.url lastObject]]];
   [_cell.mImageView sd_setImageWithURL:url];
    _indexpah=indexPath.row;
    if (isEdting==YES) {
//        _cell.cancelLabel.alpha=1;
        _cell.cancelButton.alpha=1;
//        _cell.bgView.alpha=0.5;
    }else
    {
        _cell.cancelButton.alpha=0;
        _cell.cancelButton.selected = NO;
//        _cell.cancelLabel.alpha=0;
//        _cell.bgView.alpha=0;

    }
   
    _cell.cancelButton.tag=indexPath.row;
    [_cell.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cellArray addObject:_cell];
    return _cell;
}
//点赞
-(void)zanButtonClick:(UIButton*)button
{
   collectionModel* collectModel=[self.array objectAtIndex:button.tag];
    NSString* actiId=collectModel.actiId;
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length!=0) {
        [userModel clippraise:useId withactiId:actiId];
        [userModel setBlockWithReturnBlock:^(id returnValue) {
        NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:0];
        collectionCell* cell=(collectionCell*)[self.tableView  cellForRowAtIndexPath:indexpath];
            NSString* num=collectModel.praiseNum ;
            NSString* string=collectModel.hasPraise;
            if (flag[button.tag]==NO) {
                if ([string isEqualToString:@"true"]) {
                    NSInteger y=[num intValue]-1;
                    cell.collectNumLabel.text=[NSString stringWithFormat:@"%ld",y];
                    flag[button.tag]=YES;
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                }else
                {
                    NSInteger y=[num intValue]+1;
                    cell.collectNumLabel.text=[NSString stringWithFormat:@"%ld",y];
                    flag[button.tag]=YES;
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                }
                
            }else
            {
                if ([string isEqualToString:@"true"]) {
                    cell.collectNumLabel.text=num;
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                    flag[button.tag]=NO;
                    
                }else
                {
                    cell.collectNumLabel.text=num;
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                    flag[button.tag]=NO;
                }
                
                
            }
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
        
    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* riliVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:riliVC animated:YES];
        
    }

}

-(void)cancelButtonClick:(UIButton*)button {
//    collectionModel* collectModel=[self.array objectAtIndex:button.tag];
//    UserViewModel* userModel=[[UserViewModel alloc]init];
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
//    [userModel cancelCollection:useId withactiId:collectModel.actiId];
//    [userModel setBlockWithReturnBlock:^(id returnValue) {
//        cancelModel* cancel=returnValue;
//        if ([cancel.flag isEqualToString:@"true"]) {
//            ALERTVIEW(@"删除成功");
//            alertView.delegate=self;
//            [self.array removeObjectAtIndex:button.tag];
//            [self.tableView reloadData];
//            [self collectionView];
//
//        }
//    } WithErrorBlock:^(id errorCode) {
//        
//    } WithFailureBlock:^{
//        
//    }];

    button.selected = !button.selected;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    collectionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectIndexes containsIndex:button.tag]) {
        // 取消选择
        [self.selectIndexes removeIndex:button.tag];
        cell.bgView.alpha = 0.0;
    }
    else {
        // 选择
        [self.selectIndexes addIndex:button.tag];
        cell.bgView.alpha = 0.5;
    }
}

//设置是否可以点击
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (isNil==NO) {
        return path;
    }else
    {
        return  nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    collectionModel* collectModel=[self.array objectAtIndex:indexPath.row];
    //UserViewModel* userModel=[[UserViewModel alloc]init];
    //[userModel getcollectionDetail:collectModel.actiId];
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailactivityViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"detailactivityViewController"];
    detailVC.actiId=collectModel.actiId;
    [self.navigationController pushViewController:detailVC animated:YES];
   // NSLog(@"%@",collectModel.actiId);
}

- (IBAction)backButtonClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Actions

- (IBAction)clickAddShoppingCart:(id)sender {
    if (self.selectIndexes.count == 0) {
        ALERTVIEW(@"请选择一个活动添加");
        
        return;
    }
    
    if (self.selectIndexes.count > 1) {
        ALERTVIEW(@"请单个添加");
        
        return;
    }
    
    collectionModel *model = self.array[self.selectIndexes.firstIndex];
    [HttpReqManager httpRequestActivityDetail:[ODataManager sharedInstance].userID activityID:model.actiId completion:^(NSDictionary<NSString *,id> * _Nonnull response) {
        if ([response[@"err_code"] isEqualToString:@"200"]) {
            NSDictionary *dic = response[@"data"][@"actiInfo"];
            actiDetailModel* detailModel = [[actiDetailModel alloc] initWithDic:dic];
            ShoppingCartItem *item = [[ShoppingCartItem alloc] init];
            [item loadInfoFromModel:detailModel];
            [HttpReqManager httpRequestAddShoppingCart:[ODataManager sharedInstance].userID shoppingCartItem:item completion:^(NSDictionary<NSString *,id> * _Nonnull response) {
                if ([response[@"err_code"] isEqualToString:@"200"]) {
                    ALERTVIEW(@"添加成功");
                }
                else {
                    ALERTVIEW(@"添加失败");
                }
            } failure:^(NSError * _Nullable error) {
                ALERTVIEW(@"添加失败");
            }];
        }
        else {
            ALERTVIEW(@"添加失败");
        }
    } failure:^(NSError * _Nullable error) {
        ALERTVIEW(@"添加失败");
    }];
}

- (IBAction)clickDelete:(id)sender {
    // TODO: 删除收藏
}

#pragma mark - Property

- (NSMutableIndexSet *)selectIndexes {
    if (!_selectIndexes) {
        _selectIndexes = [NSMutableIndexSet indexSet];
    }
    
    return _selectIndexes;
}

@end
