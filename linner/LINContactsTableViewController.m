//
//  LINContactsTableViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINContactsTableViewController.h"
#import "LINContactsTableViewController+DataModel.h"
#import "LINUserRelation.h"

#import "Reachability.h"

#import "LINProfileViewControllerFriends.h"
#import "LINCallingViewController.h"


@interface LINContactsTableViewController ()
@property (strong, nonatomic) NSArray* contactFuncArray;
@property (strong, nonatomic) NSMutableArray* contactData;
@property (strong, nonatomic) AVUser* currentUser;
@end

@implementation LINContactsTableViewController
{
    NSMutableArray * tests;
    UIBarButtonItem * prevButton;
    UITableViewCellAccessoryType accessory;
}


static NSString *CellIdentifier = @"LINContactsTableCellTableViewCell";

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
    
    self.title = @"管理";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contactFuncArray = [NSArray arrayWithObjects:@"通知", @"记录", @"用量", nil];
    
    self.tableView.delegate = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendsPush:)];
    self.currentUser = [AVUser currentUser];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LINContactsTableCellTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.contactData = [self getInitData];
    [self.tableView reloadData];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus != NotReachable)
        [self loadingDataFromRemote];
}

-(void)loadingDataFromRemote
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.contactData = [self getDataFromRemote];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    });

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addFriendsPush:(UIBarButtonItem *)sender{
    
    LINAddFriendsTableViewController* chatDetailVC = [LINAddFriendsTableViewController alloc];
    chatDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chatDetailVC animated:YES];

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
    if(section == 0){
        return 3;
    }else{
        NSLog(@"%d", [self.contactData count]);
        return [self.contactData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ExploreViewCellIdentifier = @"regularContactCell";
    FAKIonIcons *cellIcon;
    
    
    if(indexPath.section == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExploreViewCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExploreViewCellIdentifier];
        }
        
        cell.textLabel.text = [self.contactFuncArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(indexPath.row == 0)
            cellIcon = [FAKIonIcons radioWavesIconWithSize:40];
        else if(indexPath.row == 1)
            cellIcon = [FAKIonIcons ios7BookmarksIconWithSize:40];
        else
            cellIcon = [FAKIonIcons podiumIconWithSize:40];
        
        
        [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
        cell.imageView.image = [cellIcon imageWithSize:CGSizeMake(40, 40)];
        
        return cell;
        
    }else{
        LINContactsTableCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LINContactsTableCellTableViewCell"];
        LINUserRelation* userRelation = [self.contactData objectAtIndex:indexPath.row];
        
        NSLog(@"info %d", userRelation.allowCallByPhoneNumber);
        
        cellIcon = [FAKIonIcons checkmarkCircledIconWithSize:15];
        if (userRelation.allowCallByApp && !userRelation.allowCallByPhoneNumber) {
            [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
            cell.callingCertifiedImageView.image = [cellIcon imageWithSize:CGSizeMake(15, 15)];
        }else if(userRelation.allowCallByPhoneNumber){
            [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
            cell.callingCertifiedImageView.image = [cellIcon imageWithSize:CGSizeMake(15, 15)];
        }else{
            cell.callingCertifiedImageView.image = nil;
            cell.callingCertifiedImageView.hidden = YES;
        }
        
        cell.ContactTableViewThumbImage.layer.cornerRadius = cell.ContactTableViewThumbImage.frame.size.width/2;
        cell.ContactTableViewThumbImage.layer.masksToBounds = YES;
        
        if (userRelation.userObject.userProfilePhoto == nil) {
            cellIcon = [FAKIonIcons ios7PersonIconWithSize:40];
            [cellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
            cell.ContactTableViewThumbImage.image = [cellIcon imageWithSize:CGSizeMake(40, 40)];
        }else{
            cell.ContactTableViewThumbImage.image = [UIImage imageWithData:userRelation.userObject.userProfilePhoto];
        }
        
        cell.ContactTableViewCellNameLable.text = userRelation.userObject.userRealName;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LINUserRelation* userRelation = [self.contactData objectAtIndex:indexPath.row];
    if (!userRelation.allowCallByApp)
        return;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LINNotificationTableViewController* notiVC = [[LINNotificationTableViewController alloc]init];
            [self showViewController:notiVC sender:nil];
        }
    }else{
        LINUserRelation* userRelation = [self.contactData objectAtIndex:indexPath.row];
        
        LINProfileViewControllerFriends* profileForFirendVC = [[LINProfileViewControllerFriends alloc] initWithNibName:@"LINProfileFriend" bundle:nil];
        
        profileForFirendVC.targetRelation = userRelation;
        profileForFirendVC.hidesBottomBarWhenPushed = YES;
        
        [self showViewController:profileForFirendVC sender:nil];

    }
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:@"Call" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
        LINCallingViewController *callingVC = [storyboard instantiateViewControllerWithIdentifier:@"LINCallingViewController"];
        LINUserRelation* targetUserRelation = [self.contactData objectAtIndex:indexPath.row];
        id<SINCall> call = [self.client.callClient callUserWithId:[NSString stringWithFormat:@"%@", targetUserRelation.toUserId]];
        callingVC.call = call;
        [self presentViewController:callingVC animated:YES completion:nil];
        
        [self.tableView setEditing:NO];
    }];
    moreAction.backgroundColor = [UIColor greenColor];
    
    return @[moreAction];
}

// From Master/Detail Xcode template
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (id<SINClient>)client {
    return [(LINAppDelegate *)[[UIApplication sharedApplication] delegate] client];
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-10, 20)];
        
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = @"#";
        
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithHexString:@"#D7D7D7" alpha:0.6]];
        return view;
    }
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"o", @"p",nil];
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
    return 55.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
@end
