//
//  LINSettingGeneralControl.m
//  linner
//
//  Created by Lincan Li on 9/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingGeneralControl.h"
#import "LINInitPageSelect.h"
#import "LINFontSizeEditView.h"
#import "LINMultiLangView.h"

#import "Reachability.h"

@interface LINSettingGeneralControl ()

@property (strong, nonatomic) NSArray *generalControlArray;

@end

@implementation LINSettingGeneralControl


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.generalControlArray = [NSArray arrayWithObjects:@"多语言", @"字体大小", @"初始页面", @"使用量", @"清空聊天记录", nil];
    
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
        return 2;
    }else if(section == 1){
        return 1;
    }else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PersonalProfileCellIndentifier = @"SettingTableViewProfileCellIdentifier";
    FAKIonIcons *cellIcon;
    NSUInteger rowNo;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalProfileCellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonalProfileCellIndentifier];
        //add a switch
    }
    
    if(indexPath.section == 0){
        rowNo = 0;
    }else if (indexPath.section == 1){
        rowNo = 2;
    }else{
        rowNo = 3;
    }
    
    switch (rowNo + indexPath.row) {
        case 0:
            cellIcon = [FAKIonIcons clipboardIconWithSize:30];
            break;
            
        case 1:
            cellIcon = [FAKIonIcons ios7InformationEmptyIconWithSize:50];
            break;
            
        case 2:
            cellIcon = [FAKIonIcons ios7HomeIconWithSize:30];
            break;
            
        case 3:
            cellIcon = [FAKIonIcons ios7PieIconWithSize:30];
            break;

        default:
            cellIcon = [FAKIonIcons ios7MinusOutlineIconWithSize:30];
            break;
    }


    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [self.generalControlArray objectAtIndex:rowNo + indexPath.row];
    
    [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
    cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(30, 30)];
    cell.detailTextLabel.text = @"";
    
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"个人资料";
    }else{
        return @"";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger rowNo;
    
    
    if(indexPath.section == 0)
        rowNo = 0;
    else if (indexPath.section == 1)
        rowNo = 2;
    else
        rowNo = 3;
    
    if (rowNo + indexPath.row == 0) {
        
        LINMultiLangView* MultiLangView = [LINMultiLangView alloc];
        MultiLangView.hidesBottomBarWhenPushed = YES;
        MultiLangView.userSetting = self.userSetting;
        [self.navigationController pushViewController:MultiLangView animated:YES];
        
    }else if (rowNo + indexPath.row == 1){
        
        LINFontSizeEditView* FontSizeEditView = [LINFontSizeEditView alloc];
        FontSizeEditView.hidesBottomBarWhenPushed = YES;
        FontSizeEditView.userSetting = self.userSetting;
        [self.navigationController pushViewController:FontSizeEditView animated:YES];
        
    }else if (rowNo + indexPath.row == 2){
        
        LINInitPageSelect* InitPageSelect = [LINInitPageSelect alloc];
        InitPageSelect.hidesBottomBarWhenPushed = YES;
        InitPageSelect.userSetting = self.userSetting;
        [self.navigationController pushViewController:InitPageSelect animated:YES];
        
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
