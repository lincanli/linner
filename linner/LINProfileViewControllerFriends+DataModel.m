//
//  LINProfileViewControllerFriends+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/23/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileViewControllerFriends+DataModel.h"

@implementation LINProfileViewControllerFriends (DataModel)

-(LINMessageList *) messageListInit: (LINUserRelation *) targetUserRelation;
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"MessageList" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"toUserId == %@", targetUserRelation.userObject.userId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [dataModel executeFetchRequest:request error:&error];

    if ([results count] != 0)
        return [results objectAtIndex:0];
    
    LINMessageList* messageList = [NSEntityDescription insertNewObjectForEntityForName:@"MessageList" inManagedObjectContext:dataModel];
    
    messageList.toUserId = targetUserRelation.userObject.userId;
    messageList.NewNo = 0;
    messageList.read = YES;
    messageList.updatedAt = [NSDate date];
    messageList.targetUserObject = targetUserRelation.userObject;
    messageList.targetUserRelation = targetUserRelation;
    
    [dataModel save:&error];
    
    return messageList;
}

@end
