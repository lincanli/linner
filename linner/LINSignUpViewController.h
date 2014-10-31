//
//  LINSignUpViewController.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINMainViewController.h"
#import "LINPhoneNumberSelectTableViewController.h"

@interface LINSignUpViewController : UIViewController <UITextFieldDelegate, LINPhoneNumberSelectTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userPhoneNummberTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmSignUpButton;

@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;
@end
