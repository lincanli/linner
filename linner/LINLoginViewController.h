//
//  LINLoginViewController.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINMainViewController.h"
#import "LINPhoneNumberSelectTableViewController.h"

@interface LINLoginViewController : UIViewController <UITextFieldDelegate, LINPhoneNumberSelectTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumherTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeButton;

@end