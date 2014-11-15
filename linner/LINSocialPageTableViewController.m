//
//  LINSocialPageTableViewController.m
//  Linner
//
//  Created by Lincan Li on 11/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageTableViewController.h"
#import "LINSocialPageTableViewController+DataModel.h"
#import "Reachability.h"

#import "LINNewSocialViewController.h"
#import "LINSocialRecord.h"

@interface LINSocialPageTableViewController ()
@property (strong, nonatomic) LINUserObject* currentUserObject;
@property (strong, nonatomic) NSMutableArray* socialData;

@end

@implementation LINSocialPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一句话";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    self.headerImagView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    self.currentUserObject = [self returnSelf];
    self.userNameLabel.text = self.currentUserObject.userRealName;
    
    UIImage* userProfilePhoto = [[UIImage alloc]initWithData:self.currentUserObject.userProfilePhoto];
    
    if (userProfilePhoto != nil) {
        self.userProfilePhoto.image =  [self imageWithImage:userProfilePhoto scaledToSize:CGSizeMake(90, 90)];
        self.userProfilePhoto.backgroundColor =[UIColor whiteColor];
    }else{
        FAKIonIcons *aIcon = [FAKIonIcons personStalkerIconWithSize:90];
        [aIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1D77EF" alpha:0.6]];
        self.userProfilePhoto.image = [aIcon imageWithSize:CGSizeMake(80, 80)];
    }
    
    self.userProfilePhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userProfilePhoto.layer.borderWidth = 1.0f;
    self.userProfilePhoto.layer.masksToBounds = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newSocial:)];
    
    self.socialData = [self getInitData];
    [self.socialData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"socialRecordId" ascending:NO]]];

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if(internetStatus != NotReachable)
        [self loadingDataFromRemote];
}

-(void)loadingDataFromRemote
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.socialData = [self getDataFromRemote];
        NSLog(@"queried : %d", [self.socialData count]);
        [self.socialData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"socialRecordId" ascending:NO]]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    });
    
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.userProfilePhoto.layer.cornerRadius = 45;
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newSocial: (id) sender
{
    UIStoryboard *socialStoryBoard = [UIStoryboard storyboardWithName:@"SocialPageView" bundle:nil];
    LINNewSocialViewController *newSocialVC = [socialStoryBoard instantiateViewControllerWithIdentifier:@"LINNewSocialViewController"];
    newSocialVC.hidesBottomBarWhenPushed = YES;
    [self showViewController:newSocialVC sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.socialData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LINSocialPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"socialPageCellIndentifier" forIndexPath:indexPath];
    LINSocialRecord* socialRecord = [self.socialData objectAtIndex:indexPath.row];
    
    cell.mainTextView.text = socialRecord.content;
    cell.mainTextView.font = [UIFont fontWithName:@"Helvetica" size:22];
    cell.mainTextView.textColor = [UIColor whiteColor];
    cell.mainTextView.textAlignment = NSTextAlignmentCenter;
    
    if ([socialRecord.backgroundType isEqualToNumber:[NSNumber numberWithInt:1]]) {
        cell.baseImageView.image = [UIImage imageWithData:socialRecord.backgroundImage];
    }
    
    cell.usernameLabel.text = socialRecord.fromUserObject.userRealName;
    cell.userProfilePhoto.image = [UIImage imageWithData:socialRecord.fromUserObject.userProfilePhoto];
    
    cell.userProfilePhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.userProfilePhoto.layer.borderWidth = 1.0f;
    cell.userProfilePhoto.layer.cornerRadius = 17.5;
    cell.userProfilePhoto.layer.masksToBounds = YES;
    
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width;
}

-(void) swipeBegan: (id) sender
{
//    self.tableView.scrollEnabled = NO;
}

-(void) swipeEnd: (id) sender
{
//    self.tableView.scrollEnabled = YES;
}

@end
