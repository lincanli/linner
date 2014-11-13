//
//  LINSocialPageTableViewController.m
//  Linner
//
//  Created by Lincan Li on 11/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageTableViewController.h"

#import "LINNewSocialViewController.h"

@interface LINSocialPageTableViewController ()

@end

@implementation LINSocialPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一句话";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newSocial:)];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.headerImagView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LINSocialPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"socialPageCellIndentifier" forIndexPath:indexPath];
    
    cell.mainTextView.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type";
    cell.mainTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.mainTextView.textColor = [UIColor whiteColor];
    cell.mainTextView.textAlignment = NSTextAlignmentCenter;
    
    cell.delegate = self;
    return cell;
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
