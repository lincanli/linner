//
//  LINProfileViewControllerFriends.h
//  Linner
//
//  Created by Lincan Li on 10/23/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINUserRelation.h"

@interface LINProfileViewControllerFriends : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNikeName;

@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UILabel *userMood;

@property (strong, nonatomic) LINUserRelation* targetRelation;
@end
