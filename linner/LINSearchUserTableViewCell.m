//
//  LINSearchUserTableViewCell.m
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSearchUserTableViewCell.h"

@implementation LINSearchUserTableViewCell

@synthesize searchImageView = _searchImageView;
@synthesize searchTextEditor = _searchTextEditor;
@synthesize errorLable = _errorLable;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
