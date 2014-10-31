//
//  LINProfileViewControllerNormal.h
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINProfileViewControllerNormal : UIViewController

@property (nonatomic, strong) AVObject* targetUserObject;
@property (nonatomic) BOOL ifHasNotification;
@property (nonatomic) BOOL ifAlreadyFriends;

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UIButton *profileLike;

@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *locationLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end
