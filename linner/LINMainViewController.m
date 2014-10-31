//
//  LINMainViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINMainViewController.h"

@interface LINMainViewController ()

@end

@implementation LINMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    LINChatNavViewController *chatNavController = [[LINChatNavViewController alloc] initWithRootViewController:[[LINChatTableViewController alloc] init]];
    LINContactsViewController *contactNavController = [[LINContactsViewController alloc] initWithRootViewController:[[LINContactsTableViewController alloc] init]];
    LINExploreViewController *exploreNavController = [[LINExploreViewController alloc] initWithRootViewController:[[LINExploreTableViewController alloc] init]];
    LINSettingViewController *settingNavController = [[LINSettingViewController alloc] initWithRootViewController:[[LINSettingTableViewController alloc] init]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backItem.backBarButtonItem.tintColor = [UIColor blackColor];
    self.viewControllers = [NSArray arrayWithObjects:chatNavController, contactNavController, exploreNavController, settingNavController, nil];
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"#007AFF" alpha:0.7]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#F7F7F7" alpha:1]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
