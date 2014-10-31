//
//  LINProfileViewControllerPointToPointTableViewController.h
//  Linner
//
//  Created by Lincan Li on 10/27/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINMessageList.h"
#import "LINUserRelation.h"

@interface LINProfileTableViewControllerPointToPoint : UITableViewController

@property (strong, nonatomic) LINUserRelation* targetUserRelation;
@property (strong, nonatomic) LINMessageList* messageList;

@end
