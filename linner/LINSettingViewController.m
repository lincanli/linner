//
//  LINSettingViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingViewController.h"
#import <HexColors/HexColor.h>
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface LINSettingViewController ()

@end

@implementation LINSettingViewController

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
    self.tabBarItem.title = @"设置";
    
    FAKIonIcons *gearIcon = [FAKIonIcons ios7GearOutlineIconWithSize:30];
    self.tabBarItem.image = [gearIcon imageWithSize:CGSizeMake(30, 30)];
    
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F7F7F7" alpha:1];
    self.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#4A4A4A" alpha:1]};
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
