//
//  LINSocialPageTableViewCell.m
//  Linner
//
//  Created by Lincan Li on 11/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageTableViewCell.h"

@interface LINSocialPageTableViewCell()

@property (nonatomic) CGPoint beganPoint;
@property (nonatomic) CGPoint endPoint;

@end

@implementation LINSocialPageTableViewCell

@synthesize baseImageView = _baseImageView;
@synthesize mainTextView = _mainTextView;
@synthesize likeLabel = _likeLabel;
@synthesize likeButton = _likeButton;
@synthesize userProfilePhoto = _userProfilePhoto;
@synthesize usernameLabel = _usernameLabel;

- (void)awakeFromNib {
    // Initialization code
    self.mainTextView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.mainTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.mainTextView.layer.shadowOpacity = 1.0f;
    self.mainTextView.layer.shadowRadius = 1.0f;
    
    self.likeLabel.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.likeLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.likeLabel.layer.shadowOpacity = 1.0f;
    self.likeLabel.layer.shadowRadius = 1.0f;
    
    self.usernameLabel.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.usernameLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.usernameLabel.layer.shadowOpacity = 1.0f;
    self.usernameLabel.layer.shadowRadius = 1.0f;
    
    FAKIonIcons *heartIconOutline = [FAKIonIcons ios7HeartOutlineIconWithSize:40];
    [heartIconOutline addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKIonIcons *heartIcon = [FAKIonIcons ios7HeartIconWithSize:40];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    
    [self.likeButton setImage:[heartIconOutline imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.likeButton setImage:[heartIcon imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
    
    
    
    UISwipeGestureRecognizer* gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    gestureLeft.delegate = self;
    [self.contentView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer* gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    gestureRight.delegate = self;
    [self.contentView addGestureRecognizer:gestureRight];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) swipeLeft: (UISwipeGestureRecognizer *) sender
{
    self.topViewLeftContraint.constant = -108;
    self.topViewRightContraint.constant = -8;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void) swipeRight: (UISwipeGestureRecognizer *) sender
{
    self.topViewLeftContraint.constant = -8;
    self.topViewRightContraint.constant = -108;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.beganPoint = [[touches anyObject] locationInView:self];
    
    [self.delegate swipeBegan:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    if (abs(currentPoint.x - self.beganPoint.x) < 100) {

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.endPoint = [[touches anyObject] locationInView:self];
    [self.delegate swipeEnd:touches];
}


@end
