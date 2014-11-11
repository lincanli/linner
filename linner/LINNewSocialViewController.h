//
//  LINNewSocialViewController.h
//  Linner
//
//  Created by Lincan Li on 11/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINNewSocialViewController : UIViewController <UITextViewDelegate, NSLayoutManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;
@property (weak, nonatomic) IBOutlet UITextView *socialTextView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageTextLable;

@end
