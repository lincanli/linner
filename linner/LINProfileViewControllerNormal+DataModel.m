//
//  LINProfileViewControllerNormal+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileViewControllerNormal+DataModel.h"

@implementation LINProfileViewControllerNormal (DataModel)

- (void) addFriendRequest: (AVObject *) targetUserObject
{

    AVObject* appNotification = [AVObject objectWithClassName:@"appNotification"];
    AVUser* currentUser = [AVUser currentUser];
    
    [appNotification setObject:[currentUser objectForKey:@"userId"] forKey:@"fromUserId"];
    [appNotification setObject:[targetUserObject objectForKey:@"userId"] forKey:@"toUserId"];
    
    [appNotification setObject:[NSString stringWithFormat:@"{Content:{} ; Time: %@}", [NSDate date]] forKey:@"notificationContent"];
    [appNotification setObject:[NSNumber numberWithInt:3] forKey:@"type"];
    [appNotification setObject:[NSNumber numberWithBool:NO] forKey:@"read"];
    [appNotification setObject:[NSNumber numberWithBool:NO] forKey:@"acted"];
    
    [appNotification setObject:currentUser forKey:@"fromUserObject"];
    [appNotification setObject:targetUserObject forKey:@"toUserObject"];
    
    [appNotification saveEventually];


}

@end
