//
//  LINPersonalProfileTableViewController.h
//  linner
//
//  Created by Lincan Li on 8/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINEmailEditingView.h"
#import "LINNameEditView.h"
#import "LINSexEditView.h"
#import "LINDescriptionView.h"
#import "LINBirthdayEditView.h"
#import "LINLocationEditView.h"
#import "LINUserObject.h"

@interface LINPersonalProfileTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) LINUserObject* userObject;

@end
