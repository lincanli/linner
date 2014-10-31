//
//  LINLogOutTableViewCell.m
//  linner
//
//  Created by Lincan Li on 9/10/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINLogOutTableViewCell.h"

@implementation LINLogOutTableViewCell
@synthesize LogoutLable = _LogoutLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
