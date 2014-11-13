//
//  LINSocialPageTableViewController.h
//  Linner
//
//  Created by Lincan Li on 11/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINSocialPageTableViewCell.h"


@interface LINSocialPageTableViewController : UITableViewController <LINSocialPageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImagView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
