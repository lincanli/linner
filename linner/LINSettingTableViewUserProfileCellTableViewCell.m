//
//  LINSettingTableViewUserProfileCellTableViewCell.m
//  linner
//
//  Created by Lincan Li on 7/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingTableViewUserProfileCellTableViewCell.h"

@implementation LINSettingTableViewUserProfileCellTableViewCell

@synthesize SettingTableViewCellThumbnailImage = _SettingTableViewCellThumbnailImage;
@synthesize SettingTableViewCellNameLable = _SettingTableViewCellNameLable;
@synthesize SettingTableViewCellDescriptionLable = _SettingTableViewCellDescriptionLable;
@synthesize balanceLable = _balanceLable;

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
