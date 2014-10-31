//
//  LINFinanceControlTableViewController.m
//  Linner
//
//  Created by Lincan Li on 10/30/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINFinanceControlTableViewController.h"
#import "LINFinanceControlTableViewCellBalance.h"
#import "LINPaymentViewController.h"

@interface LINFinanceControlTableViewController ()
@property (strong, nonatomic) NSArray* financeControlData;
@end

@implementation LINFinanceControlTableViewController
static NSString* balanceCellIdentifier = @"FinanceControlCellBalanceIndentifier";
static NSString* cardsCellIdentifier = @"FinanceControlCellCardsIndentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    self.financeControlData = @[@"0001"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LINFinaceControlCellBalance" bundle:nil] forCellReuseIdentifier:balanceCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LINFinanceControlTableViewCellBalance *cell = [self.tableView dequeueReusableCellWithIdentifier:balanceCellIdentifier];
        NSLog(@"cell %@", cell);
        return cell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardsCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardsCellIdentifier];
        }
        cell.textLabel.text = [self.financeControlData objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        LINPaymentViewController* paymentVC = [[LINPaymentViewController alloc]init];
        [self showViewController:paymentVC sender:nil];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        topLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7" alpha:1];
        [cell.contentView addSubview:topLineView];
    }
    
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7" alpha:1];
        [cell.contentView addSubview:bottomLineView];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110.0;
    }
    return 44.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 34.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


@end
