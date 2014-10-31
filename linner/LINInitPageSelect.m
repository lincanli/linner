//
//  LINInitPageSelect.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINInitPageSelect.h"
#import "LINSettingDataHelper.h"

@interface LINInitPageSelect ()
@property (strong, nonatomic) NSArray* pageInitOption;
@property (strong, nonatomic) UIImageView* checkView;
@end

@implementation LINInitPageSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pageInitOption = [NSArray arrayWithObjects:@"聊天", @"电话", @"上次退出时选项", nil];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButton:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalProfileCellIndentifier = @"SettingTableViewProfileCellIdentifier";
    FAKIonIcons *cellIcon;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalProfileCellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonalProfileCellIndentifier];
        //add a switch
    }
    
    if (indexPath.row == 0) {
        cellIcon = [FAKIonIcons androidKeypadIconWithSize:30];
    }else if(indexPath.row == 1){
        cellIcon = [FAKIonIcons androidChatIconWithSize:30];
    }else{
        cellIcon = [FAKIonIcons eyeIconWithSize:30];
    }
    
    if (indexPath.row == [self.userSetting.pageInit intValue])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.pageInitOption objectAtIndex:indexPath.row];
    
    [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
    cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(30, 30)];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (int i=0; i<2; i++) {
        if (i != indexPath.row) {
            NSIndexPath* allIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *allCell = [tableView cellForRowAtIndexPath:allIndexPath];
            allCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
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

-(void) confirmButton: (UIBarButtonItem *)sender
{
    
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j){
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i){
            [cells addObject:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
        }
    }
    
    for (UITableViewCell *cell in cells){
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
            NSError* error = nil;
            
            switch (indexPath.row) {
                case 0:
                    self.userSetting.pageInit = [NSNumber numberWithInt:0];
                    break;
                case 1:
                    self.userSetting.pageInit = [NSNumber numberWithInt:1];
                    break;
                default:
                    self.userSetting.pageInit = [NSNumber numberWithInt:2];
                    break;
            }
            
            
            [dataModel save:&error];
            
            LINSettingDataHelper* helper = [LINSettingDataHelper alloc];
            [helper saveForUserSetting:self.userSetting.pageInit forKey:@"pageInit"];
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
    
}


@end
