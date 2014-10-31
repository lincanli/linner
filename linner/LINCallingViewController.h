//
//  LINCallingViewController.h
//  linner
//
//  Created by Lincan Li on 9/14/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINPhoneViewController.h"


@interface LINCallingViewController : UIViewController <SINCallDelegate>

@property (weak, nonatomic) IBOutlet UIView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usrName;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIButton *speaker;
@property (weak, nonatomic) IBOutlet UIButton *record;
@property (weak, nonatomic) IBOutlet UIButton *mute;
@property (weak, nonatomic) IBOutlet UIButton *finish;

@property (nonatomic, readwrite, strong) NSTimer *durationTimer;
@property (nonatomic, readwrite, strong) id<SINCall> call;

@end
