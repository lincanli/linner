//
//  LINNotificationTableViewCell.m
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNotificationTableViewCellFriendRequest.h"

@implementation LINNotificationTableViewCellFriendRequest

@synthesize userProfilePhoto = _userProfilePhoto;
@synthesize userName = _userName;
@synthesize notiDetail = _notiDetail;
@synthesize confirmRequest = _confirmRequest;

- (void)awakeFromNib {
    // Initialization code
    self.userProfilePhoto.layer.cornerRadius = self.userProfilePhoto.frame.size.width/2;
    self.userProfilePhoto.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
