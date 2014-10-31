//
//  LINSearchUserTableViewCell.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINSearchUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextEditor;
@property (weak, nonatomic) IBOutlet UILabel *errorLable;

@end
