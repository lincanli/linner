//
//  LINiForgetViewController.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface LINiForgetViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumeberTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
