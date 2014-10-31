//
//  LINAddFriendsTableViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAddFriendsTableViewController.h"

@interface LINAddFriendsTableViewController (DataModel)

-(AVObject *) returnUserObject: (NSString *) userName;
-(BOOL) ifAleadyHasNotification: (NSNumber *) userId;
-(BOOL) ifAleadyFriends: (NSNumber *) userId;

@end
