//
//  LINSignUpViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSignUpViewController.h"
#import "LINLoginSignUpDataHelper.h"

#import "LINPhoneNumberSelectTableViewController.h"

@interface LINSignUpViewController ()

@property (strong, nonatomic) NSString* countryCode;

@end

@implementation LINSignUpViewController

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
    
    UIView * phoneNumherTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    UIView * userNameTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    UIView * passwordTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    
    self.userPhoneNummberTextField.layer.cornerRadius = 3;
    self.userPhoneNummberTextField.layer.masksToBounds = YES;
    self.userPhoneNummberTextField.leftView = phoneNumherTextFieldPaddingView;
    self.userPhoneNummberTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.userNameTextField.layer.cornerRadius = 3;
    self.userNameTextField.layer.masksToBounds = YES;
    self.userNameTextField.leftView = userNameTextFieldPaddingView;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.userPasswordTextField.layer.cornerRadius = 3;
    self.userPasswordTextField.layer.masksToBounds = YES;
    self.userPasswordTextField.leftView = passwordTextFieldPaddingView;
    self.userPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)signInDidTouched:(id)sender {
    
    AVUser * currentUser = [AVUser user];
    
    NSString* userName = [NSString stringWithFormat:@"%@%@", self.countryCode, self.userPhoneNummberTextField.text];

    currentUser.username = userName;
    currentUser.password = self.userPasswordTextField.text;
    [currentUser setObject:self.userNameTextField.text forKey:@"name"];
    
    [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            AVUser* currentUser = [AVUser currentUser];
            LINLoginSignUpDataHelper* helper = [LINLoginSignUpDataHelper alloc];
            
            if([helper saveForUserObject:currentUser.username signUp:YES]){
                LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                [appDelegate initSinchClientWithUserId:[NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]]];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                LINMainViewController* mainViewController = [[LINMainViewController alloc] init];
                self.view.window.rootViewController = mainViewController;
            }
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message: [NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)countryCodeDidTouched:(id)sender
{
    LINPhoneNumberSelectTableViewController* phoneNumberSelectVC = [[LINPhoneNumberSelectTableViewController alloc]initWithNibName:@"LINPhoneNumberSelectionView" bundle:nil];
    phoneNumberSelectVC.delegate = self;
    [self presentViewController:phoneNumberSelectVC animated:YES completion:nil];
    
}
- (void) didSelectedCountry: (id) sender
{
    self.countryCode = sender;
    if (!self.countryCode) {
        self.countryCode = @"+1";
    }
    [self.countryCodeButton setTitle:self.countryCode forState:UIControlStateNormal];
    
}
- (IBAction)readyHaveAccountDidTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)TextField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // dismiss keyboard when background is touched
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
