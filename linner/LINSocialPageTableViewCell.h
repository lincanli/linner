//
//  LINSocialPageTableViewCell.h
//  Linner
//
//  Created by Lincan Li on 11/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LINSocialPageTableViewCellDelegate <NSObject>

- (void) swipeBegan: (id) sender;
- (void) swipeEnd: (id) sender;

@end

@interface LINSocialPageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *userProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewRightContraint;

@property (weak, nonatomic) id<LINSocialPageTableViewCellDelegate> delegate;

@end
