//
//  LINExploreTableViewController.m
//  linner
//
//  Created by Lincan Li on 7/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINExploreTableViewController.h"
#import "LINSocialPageTableViewController.h"

@interface LINExploreTableViewController ()
@property (strong, nonatomic) NSArray* exploreArray;
@end

@implementation LINExploreTableViewController

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
    
    self.title = @"发现";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.exploreArray = [NSArray arrayWithObjects:@"一句话", @"附近的人", @"随机好友", @"照片加友", nil];
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
        return 1;
    }else{
        return 3;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ExploreViewCellIdentifier = @"ExploreViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExploreViewCellIdentifier];
    FAKIonIcons *cellIcon;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExploreViewCellIdentifier];
    }
    
    if(indexPath.row+indexPath.section*1 == 0){
        cellIcon = [FAKIonIcons ios7IonicOutlineIconWithSize:30];
    }else if(indexPath.row+indexPath.section*1 == 1){
        cellIcon = [FAKIonIcons personStalkerIconWithSize:30];
    }else if (indexPath.row+indexPath.section*1 == 2){
        cellIcon = [FAKIonIcons ios7HelpIconWithSize:30];
    }else{
        cellIcon = [FAKIonIcons androidCameraIconWithSize:30];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    cell.textLabel.text = [self.exploreArray objectAtIndex:indexPath.row+indexPath.section*1];
    
    [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
    cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(30, 30)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UIStoryboard *socialStoryBoard = [UIStoryboard storyboardWithName:@"SocialPageView" bundle:nil];
        LINSocialPageTableViewController *SocialPageVC = [socialStoryBoard instantiateViewControllerWithIdentifier:@"LINSocialPageTableViewControllerIdentifier"];
        SocialPageVC.hidesBottomBarWhenPushed = YES;
        [self showViewController:SocialPageVC sender:nil];
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
