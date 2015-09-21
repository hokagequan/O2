//
//  agreementViewController.m
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "agreementViewController.h"
#import "agreementCell.h"
@implementation agreementViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}
//表的代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"agreementCell" owner:self options:nil]lastObject];
        
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)buttonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
