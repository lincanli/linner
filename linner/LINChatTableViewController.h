//
//  LINChatTableViewController.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "JSQMessagesViewController/JSQMessages.h"
#import "LINPhoneViewController.h"

#import "LINMessagesListViewController.h"


@interface LINChatTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, LINMessagesListViewController>
@property (strong, nonatomic) AVUser* currentUser;

@end
