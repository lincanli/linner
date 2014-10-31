//
//  LINSocialPageView.h
//  linner
//
//  Created by Lincan Li on 9/11/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFStretchableTableHeaderView.h"
#import "LINParallaxCell.h"

@interface LINSocialPageView : UITableViewController

@property (nonatomic, strong) IBOutlet UIView* stretchView;
@property (nonatomic, strong) HFStretchableTableHeaderView* stretchableTableHeaderView;

@end
