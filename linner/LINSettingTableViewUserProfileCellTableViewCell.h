 //
//  LINSettingTableViewUserProfileCellTableViewCell.h
//  linner
//
//  Created by Lincan Li on 7/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINSettingTableViewUserProfileCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *SettingTableViewCellThumbnailImage;
@property (nonatomic, weak) IBOutlet UILabel *SettingTableViewCellNameLable;
@property (nonatomic, weak) IBOutlet UILabel *SettingTableViewCellDescriptionLable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLable;

@end
