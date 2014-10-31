//
//  LINNotificationTableViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNotificationTableViewController.h"

@interface LINNotificationTableViewController (DataModel)

-(NSMutableArray *) getInitData;
-(void) confirmFriendRequesNoti: (NSNumber *) targetUserId withNotiObject: (AVObject *) notiObject;

@end
