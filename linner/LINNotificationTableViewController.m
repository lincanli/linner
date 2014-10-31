//
//  LINNotificationTableViewController.m
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNotificationTableViewController.h"
#import "LINNotificationTableViewController+DataModel.h"

@interface LINNotificationTableViewController ()
@property (strong, nonatomic) NSMutableArray* notiData;
@property (strong, nonatomic) AVUser* currentUser;
@end

@implementation LINNotificationTableViewController

static NSString* CellIndentifierForFriendRequest = @"friendRequestCellIndentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    
    self.currentUser = [AVUser currentUser];
    
    self.notiData = [self getInitData];
    
    UINib* cellForFriendRequest = [UINib nibWithNibName:@"NotificationCellForFriendRequest" bundle:nil];
    [self.tableView registerNib:cellForFriendRequest forCellReuseIdentifier:CellIndentifierForFriendRequest];

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
    NSLog(@"count : %d", [self.notiData count]);
    return [self.notiData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    LINNotificationTableViewCellFriendRequest *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifierForFriendRequest];
    cell.userName.text = [[self.notiData objectAtIndex:indexPath.row] objectForKey:@"notificationContent"];
    cell.notiDetail.text = @"请求添加好友";
    [cell.confirmRequest addTarget:self action:@selector(confirmRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) confirmRequest:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSNumber* targetUserId = [[self.notiData objectAtIndex:indexPath.row]objectForKey:@"fromUserId"];
            [self confirmFriendRequesNoti:targetUserId withNotiObject:[self.notiData objectAtIndex:indexPath.row]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.notiData removeObjectAtIndex:indexPath.row];
                [self removeItem:indexPath];
            });
        });

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
    return 55.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
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
