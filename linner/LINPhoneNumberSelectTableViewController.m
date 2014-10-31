//
//  LINPhoneNumberSelectTableViewController.m
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINPhoneNumberSelectTableViewController.h"
#import "LINPhoneNumberHelper.h"

@interface LINPhoneNumberSelectTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary* phoneNumberData;
@property (strong, nonatomic) NSArray* phoneNumberKey;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LINPhoneNumberSelectTableViewController
static NSString* phoneNumberSelectCellIndentifier = @"phoneNumberSelectCellIdentifier";

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
    
    self.tableView.delegate = self;
    
    LINPhoneNumberHelper* phoneNumberHelper = [[LINPhoneNumberHelper alloc]init];
    self.phoneNumberData = [phoneNumberHelper getPhoneNumber];
    
    self.phoneNumberKey = [[self.phoneNumberData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

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
    return [self.phoneNumberData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneNumberSelectCellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:phoneNumberSelectCellIndentifier];
    }
    
    NSString* key = [self.phoneNumberKey objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [self.phoneNumberData objectForKey:key];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectedCountry:cell.detailTextLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissViewDidTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
