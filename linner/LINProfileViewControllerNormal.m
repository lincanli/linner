//
//  LINProfileViewControllerNormal.m
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileViewControllerNormal.h"
#import "LINProfileViewControllerNormal+DataModel.h"


@interface LINProfileViewControllerNormal ()

@end

@implementation LINProfileViewControllerNormal

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
    
    AVObject* targetUserInfo = [self.targetUserObject objectForKey:@"userInfo"];
    self.userNameLable = [targetUserInfo objectForKey:@"userRealName"];
    self.descriptionLable = [targetUserInfo objectForKey:@"userDescription"];
    
    
    FAKIonIcons *closeIcon = [FAKIonIcons ios7CloseEmptyIconWithSize:40];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.dismissButton setImage:[closeIcon imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    
    
    [self.addFriendButton setTitle:@"正在发送请求" forState:UIControlStateDisabled];
    [self.addFriendButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    if (self.ifHasNotification)
        [self.addFriendButton setTitle:@"已发送好友请求" forState:UIControlStateDisabled];
    
    if (self.ifAlreadyFriends)
        [self.addFriendButton setTitle:@"已添加好友" forState:UIControlStateDisabled];
    
    if (self.ifHasNotification || self.ifAlreadyFriends)
        [self.addFriendButton setEnabled:NO];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)viewDidLayoutSubviews
{
    [self.descriptionLable sizeToFit];
    self.descriptionLable.numberOfLines = 0;
}

- (IBAction)addFriendRequestDidTouched:(id)sender
{

    self.addFriendButton.enabled = NO;
    [self addFriendRequest:self.targetUserObject];
    [self.addFriendButton setTitle:@"请求已发送" forState:UIControlStateDisabled];
    
}

- (IBAction)dismissButtonDIdTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
