//
//  LINLoginViewController.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINLoginViewController.h"
#import "LINLoginSignUpDataHelper.h"

#import "LINPhoneNumberHelper.h"

@interface LINLoginViewController ()

@property (strong, nonatomic) NSString* countryCode;

@end

@implementation LINLoginViewController

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
    
    self.countryCode = @"+1";
    
    [self.countryCodeButton setTitle:self.countryCode forState:UIControlStateNormal];
    
    UIView * phoneNumherTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    UIView * passwordTextFieldPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];

    self.phoneNumherTextField.layer.cornerRadius = 3;
    self.phoneNumherTextField.layer.masksToBounds = YES;
    self.phoneNumherTextField.leftView = phoneNumherTextFieldPaddingView;
    self.phoneNumherTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumherTextField.delegate = self;
    
    self.passwordTextField.layer.cornerRadius = 3;
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.leftView = passwordTextFieldPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    [self.loginActivityIndicator setHidesWhenStopped:YES];
    self.loginActivityIndicator.hidden = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
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
    [self.countryCodeButton setTitle:self.countryCode forState:UIControlStateNormal];

}
- (BOOL)textFieldShouldReturn:(UITextField *)TextField
{
    [self.view endEditing:YES];
    if(TextField.tag == 1){
        [self.loginActivityIndicator startAnimating];
        NSString* userName = [NSString stringWithFormat:@"%@%@", self.countryCode, self.phoneNumherTextField.text];
        NSLog(@"username : %@", userName);
        [LINAVUserObject logInWithUsernameInBackground:userName password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                
                LINLoginSignUpDataHelper* helper = [LINLoginSignUpDataHelper alloc];
                
                if([helper saveForUserObject:user.username signUp:NO]){
                    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
                    [appDelegate initSinchClientWithUserId:[NSString stringWithFormat:@"%@", [user objectForKey:@"userId"]]];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    LINMainViewController* mainViewController = [[LINMainViewController alloc] init];
                    
                    [self.loginActivityIndicator stopAnimating];
                    self.view.window.rootViewController = mainViewController;
                }
                
            } else {
                
                [self.loginActivityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
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
