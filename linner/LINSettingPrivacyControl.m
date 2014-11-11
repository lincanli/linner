//
//  LINSettingPrivacyControl.m
//  linner
//
//  Created by Lincan Li on 9/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingPrivacyControl.h"
#import "LINSettingDataHelper.h"

#import "Reachability.h"

@interface LINSettingPrivacyControl ()

@property (strong, nonatomic) NSArray *privacyControlArray;

@end


@implementation LINSettingPrivacyControl


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.privacyControlArray = [NSArray arrayWithObjects:@"好友验证", @"通过ID搜索", @"通过Email搜索", @"通过电话号码搜索", @"拨打Linner电话", @"通过软件拨打电话", @"黑名单", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    }else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalProfileCellIndentifier = @"SettingTableViewProfileCellIdentifier";
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalProfileCellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonalProfileCellIndentifier];
    }
    
    NSLog(@"deasciption : %@ ", self.userSetting.description);
    
    if (indexPath.section*4+indexPath.row == 0) {
        switchView.on = self.userSetting.requireValidation;
        
    }else if (indexPath.section*4+indexPath.row == 1){
        switchView.on = self.userSetting.friendRequestById;

    }else if (indexPath.section*4+indexPath.row == 2){
        switchView.on = self.userSetting.friendRequestByEmail;

    }else if (indexPath.section*4+indexPath.row == 3){
        switchView.on = self.userSetting.friendRequestByphoneNo;

    }else if (indexPath.section*4+indexPath.row == 4){
        switchView.on = self.userSetting.callViaLinner;

    }else if (indexPath.section*4+indexPath.row == 5){
        switchView.on = self.userSetting.callViaNo;

    }else{
        switchView = nil;
    }
    
    if(indexPath.section*4+indexPath.row != 6){
        [switchView addTarget:self action:@selector(switchChanged: withEvent:) forControlEvents:UIControlEventValueChanged];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = switchView;
    
    cell.textLabel.text = [self.privacyControlArray objectAtIndex:indexPath.row+indexPath.section*4];
    
    
    return cell;
    
}

-(void) switchChanged:(UISwitch *)sender withEvent:(UIEvent *)event
{
    LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;

    UISwitch *switchInCell = (UISwitch *)sender;
    UITableViewCell * cell = (UITableViewCell*) switchInCell.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.section*4 + indexPath.row) {
        case 0:
            self.userSetting.requireValidation = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.requireValidation ] forKey:@"requireValidation"];
            break;
            
        case 1:
            self.userSetting.friendRequestById = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.friendRequestById ] forKey:@"friendRequestById"];
            break;
            
        case 2:
            self.userSetting.friendRequestByEmail = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.friendRequestByEmail ] forKey:@"friendRequestByEmail"];
            break;
            
        case 3:
            self.userSetting.friendRequestByphoneNo = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.friendRequestByphoneNo ] forKey:@"friendRequestByphoneNo"];
            break;
            
        case 4:
            self.userSetting.callViaLinner = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.requireValidation ] forKey:@"callViaLinner"];
            break;
            
        case 5:
            self.userSetting.callViaNo = switchInCell.on;
            [helper saveForUserSetting:[NSNumber numberWithBool:self.userSetting.requireValidation ] forKey:@"callViaNo"];
            break;
        default:
            break;
    }
    
    [dataModel save:&error];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"个人资料";
    }else{
        return @"";
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
