//
//  LINProfileViewControllerPointToPointTableViewController.m
//  Linner
//
//  Created by Lincan Li on 10/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileTableViewControllerPointToPoint.h"
#import "LINProfileTableViewControllerPointToPoint+DataModel.h"

#import "LINLogOutTableViewCell.h"

@interface LINProfileTableViewControllerPointToPoint ()
@property (strong, nonatomic) NSArray* profileData;
@end

@implementation LINProfileTableViewControllerPointToPoint
static NSString* profileForPointToPointCellIdentifier = @"profileForPointToPointCellIdentifier";
static NSString* deletFriendButtonIndentifier = @"deletFriendButtonIndentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息设置";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.profileData = @[@[@"消息免打扰", @"顶置聊天"], @[@"允许用户通过软件拨打电话",@"允许用户通过手机号拨打电话", @"分享手机号"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"LogoutTableCell" bundle:nil] forCellReuseIdentifier:deletFriendButtonIndentifier];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.profileData.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == self.profileData.count) {
        return 1;
    }
    return [[self.profileData objectAtIndex:section] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section < 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileForPointToPointCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileForPointToPointCellIdentifier];
        }
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchChanged: withEvent:) forControlEvents:UIControlEventValueChanged];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0)
                switchView.on = self.messageList.enableNoti;
            
            if (indexPath.row == 1)
                switchView.on = self.messageList.topRank;
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0)
                switchView.on = self.targetUserRelation.allowCallByApp;
            
            if (indexPath.row == 1)
                switchView.on = self.targetUserRelation.allowCallByPhoneNumber;

            if (indexPath.row == 2)
                switchView.on = self.targetUserRelation.sharePhoneNumber;
                
        }
        
        cell.accessoryView = switchView;
        cell.textLabel.text = [[self.profileData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        return cell;
        
    }else{
        LINLogOutTableViewCell *cell = (LINLogOutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:deletFriendButtonIndentifier];
        cell.LogoutLable.text = @"删除好友";
        return cell;
        
    }
}


-(void) switchChanged:(UISwitch *)sender withEvent:(UIEvent *)event
{
    UISwitch *switchInCell = (UISwitch *)sender;
    UITableViewCell * cell = (UITableViewCell*) switchInCell.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            [self updateMessageList:self.messageList withSettingName:@"enableNoti" allowed:switchInCell.on];
        
        if (indexPath.row == 1)
            [self updateMessageList:self.messageList withSettingName:@"topRank" allowed:switchInCell.on];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0)
            [self updateUserRelation:self.targetUserRelation withSettingName:@"allowCallByApp" allowed:switchInCell.on];
        
        if (indexPath.row == 1)
            [self updateUserRelation:self.targetUserRelation withSettingName:@"allowCallByPhoneNumber" allowed:switchInCell.on];
        
        if (indexPath.row == 2)
            [self updateUserRelation:self.targetUserRelation withSettingName:@"sharePhoneNumber" allowed:switchInCell.on];

    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self disableUser:self.targetUserRelation];
        [[self navigationController] popViewControllerAnimated:YES];
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
