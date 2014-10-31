//
//  LINAddFriendsTableViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAddFriendsTableViewController+DataModel.h"

@implementation LINAddFriendsTableViewController (DataModel)

-(AVObject *) returnUserObject: (NSString *) userName
{
    AVQuery* query = [AVUser query];
    [query whereKey:@"username" equalTo:userName];
    [query includeKey:@"userInfo"];
    return [query getFirstObject];
}

-(BOOL) ifAleadyHasNotification: (NSNumber *) userId
{
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryFrom = [AVQuery queryWithClassName:@"appNotification"];
    [queryFrom whereKey:@"fromUserId" equalTo:[currentUser objectForKey:@"userId"]];
    
    AVQuery* queryTo = [AVQuery queryWithClassName:@"appNotification"];
    [queryTo whereKey:@"toUserId" equalTo:userId];
    
    AVQuery* queryType = [AVQuery queryWithClassName:@"appNotification"];
    [queryType whereKey:@"type" equalTo:[NSNumber numberWithInt:3]];
    
    AVQuery* queryPrimary = [AVQuery andQueryWithSubqueries:@[queryFrom, queryTo, queryType]];
    return [queryPrimary countObjects] == 0 ? NO : YES;
    
}

-(BOOL) ifAleadyFriends: (NSNumber *) userId
{
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryFrom = [AVQuery queryWithClassName:@"userRelation"];
    [queryFrom whereKey:@"fromUserId" equalTo:[currentUser objectForKey:@"userId"]];
    
    AVQuery* queryTo = [AVQuery queryWithClassName:@"userRelation"];
    [queryTo whereKey:@"toUserId" equalTo:userId];
    
    AVQuery* queryRelation = [AVQuery queryWithClassName:@"userRelation"];
    [queryRelation whereKey:@"userRelation" equalTo:[NSNumber numberWithInt:1]];
    
    AVQuery* queryPrimary = [AVQuery andQueryWithSubqueries:@[queryFrom, queryTo, queryRelation]];
    return [queryPrimary countObjects] == 0 ? NO : YES;
    
}

@end
