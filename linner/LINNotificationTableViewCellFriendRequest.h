//
//  LINNotificationTableViewCell.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINNotificationTableViewCellFriendRequest : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *notiDetail;
@property (weak, nonatomic) IBOutlet UIButton *confirmRequest;

@end
