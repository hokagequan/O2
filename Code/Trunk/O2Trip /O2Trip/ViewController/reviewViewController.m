//
//  reviewViewController.m
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "reviewViewController.h"
#import "reviewCell.h"
#import "DisscussModel.h"
@implementation reviewViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    reviewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"reviewcell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"reviewCell" owner:self options:nil]lastObject];
        
    }
    DisscussModel* discussModel=[self.array objectAtIndex:indexPath.row];
    cell.titleLabel.text=discussModel.actiTitle;
    cell.textlabel.text=discussModel.dissContent;
    cell.dateLabel.text=discussModel.dissDate;
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",discussModel.actiPrice];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)deleteButtonClick:(UIButton*)button
{
    
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
