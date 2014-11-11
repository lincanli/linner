//
//  LINChatTableViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINChatTableViewController.h"
#import "LINChatTableViewController+DataModel.h"
#import "LINMessageList.h"

#import "Reachability.h"

#import "LINChatTableViewCellList.H"
#import "LINExploreTableViewController.h"


@interface LINChatTableViewController ()
@property (strong, nonatomic) NSMutableArray* messageListData;
@property (strong, nonatomic) UIActivityIndicatorView* activityIndicatorView;

@end

@implementation LINChatTableViewController
static NSString *listCellIdentifier = @"ChatListCellIndentifier";

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
    
    self.navigationController.title = @"聊天";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;

    FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:25];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *phoneButton = [[UIBarButtonItem alloc] initWithImage:[phoneIcon imageWithSize:CGSizeMake(25, 25)] style:UIBarButtonItemStylePlain target:self action:@selector(flipView:)];
    
    self.navigationItem.rightBarButtonItem = phoneButton;
    self.currentUser = [AVUser currentUser];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.navigationItem.leftBarButtonItem setCustomView:self.activityIndicatorView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"LINChatTableViewCellList" bundle:nil] forCellReuseIdentifier:listCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.messageListData = [self getInitData];
    NSLog(@"did load count : %d", [self.messageListData count]);
    [self.tableView reloadData];
}

-(void)loadingDataFromRemote
{
    [self.activityIndicatorView startAnimating];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.messageListData = [self getDataFromRemote];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.activityIndicatorView stopAnimating];
            [self.tableView reloadData];
        });
    });
    
}

-(void)flipView:(UIBarButtonItem *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
    LINPhoneViewController *phoneViewController = [storyboard instantiateViewControllerWithIdentifier:@"LINPhoneViewController"];
    [self showViewController:phoneViewController sender:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messageListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    LINMessageList* currentMessageList = [self.messageListData objectAtIndex:indexPath.row];

    LINChatTableViewCellList *cell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
    
    NSLog(@"chatRecord %@", currentMessageList.messageContent);

    cell.userName.text = currentMessageList.targetUserObject.userRealName;
    cell.chatRecord.text = currentMessageList.messageContent;
    
    if([[NSCalendar currentCalendar] isDateInToday:currentMessageList.updatedAt])
        [dateFormatter setDateFormat:@"HH:mm"];
    else
        [dateFormatter setDateFormat:@"MMM/dd"];

    cell.timeLable.text = [dateFormatter stringFromDate:currentMessageList.updatedAt];
    
    cell.userProfilePhoto.image = [UIImage imageWithData:currentMessageList.targetUserObject.userProfilePhoto];
    
    cell.userProfilePhoto.layer.cornerRadius = cell.userProfilePhoto.frame.size.width/2;
    cell.userProfilePhoto.layer.masksToBounds = YES;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LINMessageList* messageList = [self.messageListData objectAtIndex:indexPath.row];
    LINMessagesListViewController *messageListVC = [LINMessagesListViewController messagesViewController];
    messageListVC.hidesBottomBarWhenPushed = YES;
    messageListVC.messageList = messageList;
    messageListVC.targetRelation = messageList.targetUserRelation;
    [self.navigationController pushViewController:messageListVC animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        LINMessageList* currentMessageList = [self.messageListData objectAtIndex:indexPath.row];
        [self deleteCorrespondingMessgageRecord:currentMessageList];
        [self.messageListData removeObjectAtIndex:indexPath.row];
        [self removeItem:indexPath];
    }
}

-(void)removeItem:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
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
    return 60.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

#pragma mark - Demo delegate


- (void)didDismissJSQDemoViewController:(LINMessagesListViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
