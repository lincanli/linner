//
//  LINNotificationTableViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNotificationTableViewController+DataModel.h"

@implementation LINNotificationTableViewController (DataModel)


-(NSMutableArray *) getInitData
{
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryUser = [AVQuery queryWithClassName:@"appNotification"];
    [queryUser whereKey:@"toUserId" equalTo:[currentUser objectForKey:@"userId"]];
    
    AVQuery* queryActed = [AVQuery queryWithClassName:@"appNotification"];
    [queryActed whereKey:@"acted" equalTo:[NSNumber numberWithBool:NO]];
    
    AVQuery* queryPrimary = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryUser,queryActed,nil]];
    [queryPrimary includeKey:@"fromUserObject"];
    
    queryPrimary.cachePolicy = kPFCachePolicyNetworkElseCache;
    queryPrimary.maxCacheAge = 365*24*3600;
    
    NSArray* notiObjects = [queryPrimary findObjects];
    
    for (AVObject * object in notiObjects) {
        [object setObject:[NSNumber numberWithBool:YES] forKey:@"read"];
        [object save];
    }
    
    return [NSMutableArray arrayWithArray:notiObjects];
}



-(void) confirmFriendRequesNoti: (NSNumber *) targetUserId withNotiObject: (AVObject *) notiObject
{
    AVUser* currentUser = [AVUser currentUser];
    NSNumber* currentUserId = [currentUser objectForKey:@"userId"];
    
    AVQuery* queryToUserFirst = [AVQuery queryWithClassName:@"userRelation"];
    [queryToUserFirst whereKey:@"toUserId" equalTo:targetUserId];
    
    AVQuery* queryFromUserFirst = [AVQuery queryWithClassName:@"userRelation"];
    [queryFromUserFirst whereKey:@"fromUserId" equalTo:currentUserId];
    
    AVQuery* queryPrimaryFirst = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryToUserFirst,queryFromUserFirst,nil]];
    AVObject* firstRelation = [queryPrimaryFirst getFirstObject];
    
    if (firstRelation) {
        
        AVQuery* queryToUserSecond = [AVQuery queryWithClassName:@"userRelation"];
        [queryToUserSecond whereKey:@"toUserId" equalTo:targetUserId];
        
        AVQuery* queryFromUserSecond = [AVQuery queryWithClassName:@"userRelation"];
        [queryFromUserSecond whereKey:@"fromUserId" equalTo:currentUserId];
        
        AVQuery* queryPrimarySecond = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryToUserSecond,queryFromUserSecond,nil]];
        AVObject* secondRelation = [queryPrimarySecond getFirstObject];
        
        [firstRelation setObject:[NSNumber numberWithInt:1] forKey:@"userRelation"];
        [secondRelation setObject:[NSNumber numberWithInt:1] forKey:@"userRelation"];
        
        [firstRelation saveEventually];
        [secondRelation saveEventually];
        
    }else{
        
        AVObject* primaryUserRelation = [AVObject objectWithClassName:@"userRelation"];
        
        [primaryUserRelation setObject:currentUserId forKey:@"fromUserId"];
        [primaryUserRelation setObject:targetUserId forKey:@"toUserId"];
        [primaryUserRelation setObject:[NSNumber numberWithInt:1] forKey:@"userRelation"];
        [primaryUserRelation setObject:[notiObject objectForKey:@"fromUserObject"] forKey:@"toUserObject"];
        
        
        AVObject* correspondinguserRelation = [AVObject objectWithClassName:@"userRelation"];

        
        [correspondinguserRelation setObject:targetUserId forKey:@"fromUserId"];
        [correspondinguserRelation setObject:currentUserId forKey:@"toUserId"];
        [correspondinguserRelation setObject:[NSNumber numberWithInt:1] forKey:@"userRelation"];
        [correspondinguserRelation setObject:currentUser forKey:@"toUserObject"];
        
        [primaryUserRelation saveEventually];
        [correspondinguserRelation saveEventually];
        
        [notiObject setObject:[NSNumber numberWithBool:YES] forKey:@"acted"];
        [notiObject saveEventually];
        
    }

}

@end
