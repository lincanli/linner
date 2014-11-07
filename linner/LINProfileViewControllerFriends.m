//
//  LINProfileViewControllerFriends.m
//  Linner
//
//  Created by Lincan Li on 10/23/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileViewControllerFriends.h"
#import "LINProfileViewControllerFriends+DataModel.h"

#import "LINMessagesListViewController.h"
#import "LINCallingViewController.h"

@interface LINProfileViewControllerFriends ()
@property (strong, nonatomic) LINUserObject* targetUser;
@end

@implementation LINProfileViewControllerFriends

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.targetUser= self.targetRelation.userObject;
    
    self.userName.text = self.targetUser.userName;
    self.userNikeName.text = self.targetUser.userNikeName;
    self.userDescription.text = self.targetUser.userDescription;
    
    self.title = self.targetUser.userName;
    
    self.edgesForExtendedLayout = UIRectEdgeNone; 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(userSettingTouched:)];
}

-(void) userSettingTouched:(id)sender
{

}

-(void)viewDidLayoutSubviews
{
    self.userProfilePhoto.layer.cornerRadius = self.userProfilePhoto.frame.size.width/2;
    self.userProfilePhoto.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sentMessageDidTouched:(id)sender
{
    LINMessageList* messageList = [self messageListInit:self.targetRelation];

    LINMessagesListViewController* messageListVC = [[LINMessagesListViewController alloc]init];
    messageListVC.targetRelation = self.targetRelation;
    messageListVC.messageList = messageList;
    [self showViewController:messageListVC sender:nil];
}

- (IBAction)callViaProgramDidTouched:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
    LINCallingViewController *callingVC = [storyboard instantiateViewControllerWithIdentifier:@"LINCallingViewController"];
    id<SINCall> call = [self.client.callClient callUserWithId:[NSString stringWithFormat:@"%@", self.targetUser.userId]];
    callingVC.call = call;
    [self presentViewController:callingVC animated:YES completion:nil];
}

- (id<SINClient>)client {
    return [(LINAppDelegate *)[[UIApplication sharedApplication] delegate] client];
}

@end
