//
//  LINSocialComposeViewController.h
//  Linner
//
//  Created by Lincan Li on 10/20/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINSocialComposeViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *editorView;
@property (weak, nonatomic) IBOutlet UIImageView *editorImageView;
@property (weak, nonatomic) IBOutlet UITextView *editorTextView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editorHeightConstraint;

@end