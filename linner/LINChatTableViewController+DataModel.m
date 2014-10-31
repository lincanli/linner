//
//  LINChatTableViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINChatTableViewController+DataModel.h"
#import "LINMessageList.h"

@implementation LINChatTableViewController (DataModel)

-(NSMutableArray *) getInitData
{
    return [self getDataFromLocal];

}

-(NSMutableArray *) getDataFromLocal
{
    NSMutableArray* dataFromLocal;
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageList" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    dataFromLocal = [NSMutableArray arrayWithArray:[dataModel executeFetchRequest:request error:&error]];
    
    NSMutableArray* resultData = [[NSMutableArray alloc]init];

    for (LINMessageList* messsageList in dataFromLocal) {
        if (messsageList.targetUserRelation.relationActive == YES) {
            [resultData addObject:messsageList];
        }
    }
    return resultData;
}

-(void)deleteCorrespondingMessgageRecord: (LINMessageList *) messageList
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    [dataModel deleteObject:messageList];
    [dataModel save:&error];
    
}

//-(NSMutableArray *) getDataFromRemote
//{
//    NSMutableArray* dataFromRemote;
//    AVUser* currentUser = [AVUser currentUser];
//    
//    AVQuery* queryMessageList = [AVQuery queryWithClassName:@"messageList"];
//    [queryMessageList includeKey:@"toUserObject"];
//    [queryMessageList whereKey:@"fromUserId" equalTo:[currentUser objectForKey:@"userId"]];
//    NSLog(@"get my id : %@", [currentUser objectForKey:@"userId"]);
//    
//    dataFromRemote = [NSMutableArray arrayWithArray:[queryMessageList findObjects]];
//    
//    NSLog(@"get from remote count %d", [dataFromRemote count]);
//    
//    if([dataFromRemote count] != 0)
//        [self storeRemoteToLocal:dataFromRemote];
//    
//    return [self getDataFromLocal];
//}


//-(void) storeRemoteToLocal: (NSMutableArray*) remoteData
//{
//    [self deleteAllObjects:@"MessageList"];
//
//    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
//    
//    for (AVObject* object in remoteData) {
//        LINMessageList* messageList = [NSEntityDescription insertNewObjectForEntityForName:@"MessageList" inManagedObjectContext:dataModel];
//        NSError* dataModelSaveError = nil;
//        
//        messageList.toUserId = [NSNumber numberWithInt:[[object objectForKey:@"toUserId"]intValue]];
//        messageList.messageListId = [NSNumber numberWithInt:[[object objectForKey:@"messageListId"]intValue]];
//        messageList.messageContent = [object objectForKey:@"messageContent"];
//        messageList.NewNo = [NSNumber numberWithInt:[[object objectForKey:@"newNo"]intValue]];
//        messageList.read = [[object objectForKey:@"read"] boolValue];
//        messageList.updatedAt = [object objectForKey:@"updatedAt"];
//        
//        [dataModel save:&dataModelSaveError];
//    }
//    
//}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:dataModel];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [dataModel executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [dataModel deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![dataModel save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}



@end
