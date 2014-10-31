//
//  LINChatTableCellTableViewCell.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINChatTableViewCellList : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *userProfilePhoto;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *chatRecord;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;


@end
