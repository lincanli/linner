//
//  LINExploreViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINExploreViewController.h"
#import <HexColors/HexColor.h>
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface LINExploreViewController ()

@end

@implementation LINExploreViewController

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
    self.tabBarItem.title = @"发现";
    
    FAKIonIcons *navigationIcon = [FAKIonIcons ios7NavigateOutlineIconWithSize:30];
    self.tabBarItem.image = [navigationIcon imageWithSize:CGSizeMake(30, 30)];
    
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F7F7F7" alpha:1];
    self.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#4A4A4A" alpha:1]};
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
