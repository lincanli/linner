//
//  LINPersonalProfileTableViewController.m
//  linner
//
//  Created by Lincan Li on 8/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINPersonalProfileTableViewController.h"
#import "Reachability.h"

@interface LINPersonalProfileTableViewController ()

@property (strong, nonatomic) NSArray *SelfSettingData;

@end

@implementation LINPersonalProfileTableViewController



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
    self.SelfSettingData = [NSArray arrayWithObjects:@"姓名", @"Email", @"个人简介", @"性别", @"生日", @"位置", @"用量", nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
        
    }else if (section == 1){
        return 3;
        
    }else{
        return 1;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalProfileCellIndentifier = @"SettingTableViewProfileCellIdentifier";
    FAKIonIcons *cellIcon;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalProfileCellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonalProfileCellIndentifier];
    }
    
    
    if (indexPath.section*3+indexPath.row == 0) {
        cellIcon = [FAKIonIcons personIconWithSize:30];
        cell.detailTextLabel.text = self.userObject.userRealName;

    }else if (indexPath.section*3+indexPath.row == 1){
        cellIcon = [FAKIonIcons ios7AtIconWithSize:30];
        cell.detailTextLabel.text = self.userObject.userEmail;
        
    }else if (indexPath.section*3+indexPath.row == 2){
        cellIcon = [FAKIonIcons composeIconWithSize:30];
        cell.detailTextLabel.text = self.userObject.userDescription;
        
    }else if (indexPath.section*3+indexPath.row == 3){
        cellIcon = [FAKIonIcons femaleIconWithSize:30];
        cell.detailTextLabel.text = self.userObject.userSex;
        
    }else if (indexPath.section*3+indexPath.row == 4){
        cellIcon = [FAKIonIcons ios7PersonIconWithSize:30];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MMM-dd"];
        
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.userObject.userBirthday];
        
    }else if (indexPath.section*3+indexPath.row == 5){
        cellIcon = [FAKIonIcons ios7LocationIconWithSize:30];
        cell.detailTextLabel.text = self.userObject.userLocation;
        
    }else{
        cellIcon = [FAKIonIcons ios7PulseIconWithSize:30];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [self.SelfSettingData objectAtIndex:indexPath.row+indexPath.section*3];

    [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
    cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(30, 30)];
    
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"个人资料";
    }else{
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section*3+indexPath.row == 0) {
        
        LINNameEditView* NameEditView = [LINNameEditView alloc];
        NameEditView.hidesBottomBarWhenPushed = YES;
        NameEditView.userObject = self.userObject;

        [self.navigationController showViewController:NameEditView sender:nil];
        
    }else if (indexPath.section*3+indexPath.row == 1){
        
        LINEmailEditingView* EmailEditingView = [LINEmailEditingView alloc];
        EmailEditingView.hidesBottomBarWhenPushed = YES;
        EmailEditingView.userObject = self.userObject;

        [self.navigationController showViewController:EmailEditingView sender:nil];
        
    }else if (indexPath.section*3+indexPath.row == 2){
        
        LINDescriptionView* DescriptionView = [LINDescriptionView alloc];
        DescriptionView.hidesBottomBarWhenPushed = YES;
        DescriptionView.userObject = self.userObject;

        [self.navigationController showViewController:DescriptionView sender:nil];
        
    }else if (indexPath.section*3+indexPath.row == 3){
        
        LINSexEditView* SexEditView = [LINSexEditView alloc];
        SexEditView.hidesBottomBarWhenPushed = YES;
        SexEditView.userObject = self.userObject;

        [self.navigationController showViewController:SexEditView sender:nil];
        
    }else if (indexPath.section*3+indexPath.row == 4){
        
        LINBirthdayEditView* BirthdayEditView = [LINBirthdayEditView alloc];
        BirthdayEditView.hidesBottomBarWhenPushed = YES;
        BirthdayEditView.userObject = self.userObject;

        [self.navigationController showViewController:BirthdayEditView sender:nil];
        
    }else if (indexPath.section*3+indexPath.row == 5){
        
        LINLocationEditView* LocationEditView = [LINLocationEditView alloc];
        LocationEditView.hidesBottomBarWhenPushed = YES;
        LocationEditView.userObject = self.userObject;

        [self.navigationController showViewController:LocationEditView sender:nil];
        
    }else{
        //usage
        
        
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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
