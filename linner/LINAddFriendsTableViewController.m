//
//  LINAddFriendsTableViewController.m
//  linner
//
//  Created by Lincan Li on 8/12/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAddFriendsTableViewController.h"
#import "LINProfileViewControllerNormal.h"
#import "LINAddFriendsTableViewController+DataModel.h"

#import "MBProgressHUD.h"

@interface LINAddFriendsTableViewController ()

@end

@implementation LINAddFriendsTableViewController

static NSString *CellIdentifieForSearchBar = @"CellIdentifieForSearchBar";
static NSString *CellIdentifier = @"ExploretTableViewCellIdentifier";

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

    self.title = @"添加朋友";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"addFriends" bundle:nil] forCellReuseIdentifier:CellIdentifieForSearchBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
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
        return 1;
    }else if(section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    if(indexPath.section == 0) {
        
        LINSearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifieForSearchBar];
        
        FAKIonIcons *searchIcon = [FAKIonIcons searchIconWithSize:25];
        [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
        
        cell.searchImageView.image = [searchIcon imageWithSize:CGSizeMake(25, 25)];
        
        cell.searchTextEditor.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        cell.searchTextEditor.placeholder = @"搜索ID/Email/手机号";
        cell.searchTextEditor.delegate = self;
        
        cell.errorLable.hidden = YES;
        cell.errorLable.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Add By ID";
                cell.detailTextLabel.text = @"Add By ID";
                
                FAKIonIcons *aIcon = [FAKIonIcons personStalkerIconWithSize:30];
                [aIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
                cell.imageView.image = [aIcon imageWithSize:CGSizeMake(30, 30)];
                
            }else{
                cell.textLabel.text = @"Add By QR code";
                cell.detailTextLabel.text = @"Add By QR code";
                
                FAKIonIcons *aIcon = [FAKIonIcons personStalkerIconWithSize:30];
                [aIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
                cell.imageView.image = [aIcon imageWithSize:CGSizeMake(30, 30)];
            }
            
        }else{
            
            cell.textLabel.text = @"Add By Ramdom";
            cell.detailTextLabel.text = @"Detail Text Lable";
            
            FAKIonIcons *aIcon = [FAKIonIcons personStalkerIconWithSize:30];
            [aIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
            cell.imageView.image = [aIcon imageWithSize:CGSizeMake(30, 30)];
        }
        
        return cell;
    
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    }else{
        return 44;
    }
}

#pragma mark - normal grouped table view set up.

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        topLineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        [cell.contentView addSubview:topLineView];
    }
    
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        [cell.contentView addSubview:bottomLineView];
        
    }
    
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    LINSearchUserTableViewCell* cell = (LINSearchUserTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    AVObject* targetUserObject = [self returnUserObject:textField.text];
    AVUser* currentUser = [AVUser currentUser];
    
    if ([textField.text isEqualToString:[currentUser objectForKey:@"username"]]) {
        cell.errorLable.hidden = NO;
        cell.errorLable.text = @"请勿搜索自己";
        return YES;
    }
    
    if (targetUserObject) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            LINProfileViewControllerNormal * profileNormalVC = [[LINProfileViewControllerNormal alloc] initWithNibName:@"LINProfileNormal" bundle:nil];
            profileNormalVC.ifHasNotification = [self ifAleadyHasNotification:[targetUserObject objectForKey:@"userId"]];
            profileNormalVC.ifAlreadyFriends = [self ifAleadyFriends:[targetUserObject objectForKey:@"userId"]];
            profileNormalVC.targetUserObject = targetUserObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                textField.text = @"";
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDetailViewController:profileNormalVC sender:nil];
            });
        });
        
    }else{
        cell.errorLable.hidden = NO;
        cell.errorLable.text = @"没有找到此用户";
    }
    

    return YES;
}


@end
