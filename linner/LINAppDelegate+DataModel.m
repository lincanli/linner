//
//  LINAppDelegate+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/25/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAppDelegate+DataModel.h"
#import "LINMessageList.h"

@implementation LINAppDelegate (DataModel)

- (void) saveRemoteNotificationToLocal: (NSDictionary *) dictionary
{
    NSString* jsonString = [dictionary objectForKey:@"content"];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* messageData =  [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSManagedObjectContext* dataModel = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageList" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateUserId = [NSPredicate predicateWithFormat:@"toUserId == %@", [dictionary objectForKey:@"userId"]];
    [request setPredicate:predicateUserId];

    NSError *error = nil;
    NSArray* dataFromLocal = [dataModel executeFetchRequest:request error:&error];
    
    LINMessageList* messageList;
    if (dataFromLocal.count == 0) {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicateUserId = [NSPredicate predicateWithFormat:@"userId == %@", [dictionary objectForKey:@"userId"]];
        [request setPredicate:predicateUserId];
        
        NSArray* secondDataFromLocal = [dataModel executeFetchRequest:request error:&error];
        
        LINUserObject* targetUserObject;
        if (secondDataFromLocal.count == 0) {
            targetUserObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserObject" inManagedObjectContext:dataModel];
            targetUserObject.userId = [dictionary objectForKey:@"userId"];
            targetUserObject.userRealName = [[[[dictionary objectForKey:@"aps"] objectForKey:@"alert"] componentsSeparatedByString:@":"] objectAtIndex:0];
        }else{
            targetUserObject = [secondDataFromLocal objectAtIndex:0];
        }
        [dataModel save:&error];
        
        messageList = [NSEntityDescription insertNewObjectForEntityForName:@"MessageList" inManagedObjectContext:dataModel];
        messageList.NewNo = 0;
        messageList.toUserId = [messageData objectForKey:@"userId"];
        messageList.targetUserObject = targetUserObject;
        
    }else{
        messageList = [dataFromLocal objectAtIndex:0];
    }
    [self saveToMessageList:messageList withMessageData:messageData inDataModel:dataModel];
}

- (void) saveToMessageList: (LINMessageList *) messageList withMessageData: (NSDictionary *) messageData inDataModel: (NSManagedObjectContext *) dataModel
{
    NSError *error = nil;
    
    messageList.messageContent = [messageData objectForKey:@"content"];
    messageList.updatedAt = [NSDate date];
    [[self.window.rootViewController.tabBarController.tabBar.items objectAtIndex:0] setBadge:1];
    [dataModel save:&error];
}

@end
