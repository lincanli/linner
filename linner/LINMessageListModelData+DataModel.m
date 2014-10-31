//
//  LINMessageListModelData+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/22/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINMessageListModelData+DataModel.h"
#import "LINMessageList.h"

@implementation LINMessageListModelData (DataModel)

- (NSMutableArray *) getInitData: (LINUserObject *) targetUser messageList: (LINMessageList *) messageList
{
    
    return [self returnDataFromLocal:targetUser messageList:messageList recursive:NO time:[NSDate alloc]];
}

- (NSMutableArray *) returnDataFromLocal: (LINUserObject *) targerUser messageList: (LINMessageList *) messageList recursive: (BOOL) recursive time: (NSDate *) lastTime
{
    NSMutableArray* dataFromLocal;
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageRecord" inManagedObjectContext:dataModel];
    [request setEntity:entity];

    NSPredicate *predicateUserId = [NSPredicate predicateWithFormat:@"toUserId == %@", targerUser.userId];
    [request setPredicate:predicateUserId];
    
    NSPredicate *predicateMessageList = [NSPredicate predicateWithFormat:@"messageListId == %@",  [messageList.objectID URIRepresentation]];
    NSLog(@"messageListId: %@", [messageList.objectID URIRepresentation]);

    [request setPredicate:predicateMessageList];
    
    if (recursive) {
        NSPredicate *predicateTime = [NSPredicate predicateWithFormat:@"timestamp < %@", lastTime];
        [request setPredicate:predicateTime];
    }
    
    [request setFetchLimit:30];
    
    NSError *error = nil;
    NSArray* result = [dataModel executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error : %@", error);
    }
    dataFromLocal = [NSMutableArray arrayWithArray:result];
    
    return dataFromLocal;
}

@end
