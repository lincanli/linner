//
//  LINSocialPageView.m
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageView.h"
#import "LINSocialComposeViewController.h"


#import "LINNewSocialViewController.h"



@interface LINSocialPageView ()
@property (nonatomic, strong) NSArray *tableItems;
@property (strong, nonatomic) UIView* profilePic;
@property (strong, nonatomic) UITextView*profileName;
@end

@implementation LINSocialPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:_stretchView];
    
    self.tableItems = @[[UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_4.png"],
                        [UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_4.png"],
                        [UIImage imageNamed:@"demo_3.jpg"],
                        [UIImage imageNamed:@"demo_2.jpg"],
                        [UIImage imageNamed:@"demo_1.jpg"],
                        [UIImage imageNamed:@"demo_4.png"]];
    

    UIBarButtonItem *phoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToAdd:)];
    self.navigationItem.rightBarButtonItem = phoneButton;
    
    
    self.profilePic = [[UIView alloc]initWithFrame:CGRectMake(10, 170, 70, 70)];
    self.profilePic.layer.cornerRadius = 35;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.layer.borderWidth = 2;
    self.profilePic.layer.borderColor = [[UIColor groupTableViewBackgroundColor]CGColor];
    
    [self.view addSubview:self.profilePic];
    
    self.profileName = [[UITextView alloc]initWithFrame:CGRectMake(90, 190, 200, 30)];
    self.profileName.text = @"用户名";
    self.profileName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.profileName.textColor = [UIColor whiteColor];
    self.profileName.backgroundColor = [UIColor clearColor];
    self.profileName.scrollEnabled = NO;
    self.profileName.editable = NO;
    
    [self.view addSubview:self.profileName];
    
    
}

-(void) pushToAdd:(UIBarButtonItem *)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SocialPageView" bundle:nil];
    LINNewSocialViewController *newSocialVC = [storyboard instantiateViewControllerWithIdentifier:@"LINNewSocialViewController"];
    [self showViewController:newSocialVC sender:nil];
    
//    LINSocialComposeViewController* socialComposeVC = [[LINSocialComposeViewController alloc] initWithNibName:@"LINSocialCompose" bundle:nil];
//
//    [self showViewController:socialComposeVC sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SocialCell
    static NSString *CellIdentifier = @"ParallaxCellIdentifier";
    LINParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SocialCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FAKIonIcons *likeIconOutline = [FAKIonIcons ios7HeartOutlineIconWithSize:40];
    [likeIconOutline addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKIonIcons *likeIconSolid = [FAKIonIcons ios7HeartIconWithSize:40];
    [likeIconSolid addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF5E3A" alpha:1]];
    
    [cell.likeIconButton setImage:[likeIconOutline imageWithSize:CGSizeMake(40, 40)] forState: UIControlStateNormal];
    [cell.likeIconButton setImage:[likeIconSolid imageWithSize:CGSizeMake(40, 40)] forState: UIControlStateHighlighted];
    
    [likeIconSolid addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF2A68" alpha:1]];
    [cell.likeIconButton setImage:[likeIconSolid imageWithSize:CGSizeMake(40, 40)] forState: UIControlStateSelected];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This is a parallex cell %d",),indexPath.row];
    cell.parallaxImage.image = self.tableItems[indexPath.row];
    
    cell.clipsToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 203.0;
    
}

@end
