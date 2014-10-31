//
//  LINiForgetViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINiForgetViewController.h"

@interface LINiForgetViewController ()

@end

@implementation LINiForgetViewController

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
    UIView * userPhoneNumeberTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    
    self.userPhoneNumeberTextField.layer.cornerRadius = 3;
    self.userPhoneNumeberTextField.layer.masksToBounds = YES;
    self.userPhoneNumeberTextField.leftView = userPhoneNumeberTextFieldPaddingView;
    self.userPhoneNumeberTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)sentLinkDidTouched:(id)sender {
    [AVUser requestPasswordResetForEmailInBackground:self.userPhoneNumeberTextField.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Link Sent" message:@"You will seceive an email soo regarding password reset." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Email address does not exist, please re-enter." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)backToLoginDidTouched:(id)sender {
    
    //TODO deprecated
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // dismiss keyboard when background is touched
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)TextField
{
    [TextField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
