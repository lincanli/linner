//
//  LINProfileTableViewControllerPointToPoint+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/30/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINProfileTableViewControllerPointToPoint+DataModel.h"
#import "LINUserRelation.h"

@implementation LINProfileTableViewControllerPointToPoint (DataModel)

-(void) updateUserRelation: (LINUserRelation *) targetUserRelation withSettingName: (NSString *) settingName allowed:(BOOL) allowed;
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    AVUser* currentUser = [AVUser currentUser];
    NSNumber* currentUserId = [currentUser objectForKey:@"userId"];
    
    AVQuery* queryRelation = [AVQuery queryWithClassName:@"userRelation"];
    [queryRelation whereKey:@"toUserId" equalTo:currentUserId];
    [queryRelation whereKey:@"fromUserId" equalTo:targetUserRelation.userObject.userId];
    
    AVObject* currentRelation = [queryRelation getFirstObject];
    
    
    if ([settingName isEqualToString:@"allowCallByApp"]) {
        targetUserRelation.allowCallByApp = allowed;
        [currentRelation setObject:[NSNumber numberWithBool:allowed] forKey:@"allowCallByApp"];
        
    }else if([settingName isEqualToString:@"allowCallByPhoneNumber"]) {
        targetUserRelation.allowCallByPhoneNumber = allowed;
        [currentRelation setObject:[NSNumber numberWithBool:allowed] forKey:@"allowCallByPhoneNumber"];

    }else if ([settingName isEqualToString:@"sharePhoneNumber"]){
        targetUserRelation.sharePhoneNumber = allowed;
        [currentRelation setObject:[NSNumber numberWithBool:allowed] forKey:@"sharePhoneNumber"];

    }
    
    [currentRelation saveEventually];
    [dataModel save:&error];
    
}

-(void) updateMessageList: (LINMessageList *) messageList withSettingName: (NSString *) settingName allowed:(BOOL) allowed
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    if ([settingName isEqualToString:@"topRank"]) {
        messageList.topRank = allowed;
    }else if ([settingName isEqualToString:@"enableNoti"]){
        messageList.enableNoti = allowed;
    }
    
    [dataModel save:&error];
}

-(void) disableUser: (LINUserRelation *) targetUserRelation
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;

    targetUserRelation.relationActive = NO;
    targetUserRelation.userObject.userActive = NO;
    [dataModel save:&error];
    
    if (error) {
        NSLog(@"error when disable user : %@", error);
        return;
    }
    
    AVUser* currentUser = [AVUser currentUser];
    NSNumber* currentUserId = [currentUser objectForKey:@"userId"];
    
    AVQuery* queryToUserFirst = [AVQuery queryWithClassName:@"userRelation"];
    [queryToUserFirst whereKey:@"toUserId" equalTo:targetUserRelation.userObject.userId];
    
    AVQuery* queryFromUserFirst = [AVQuery queryWithClassName:@"userRelation"];
    [queryFromUserFirst whereKey:@"fromUserId" equalTo:currentUserId];
    
    AVQuery* queryPrimaryFirst = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryToUserFirst,queryFromUserFirst,nil]];
    AVObject* firstRelation = [queryPrimaryFirst getFirstObject];
    
    
    AVQuery* queryToUserSecond = [AVQuery queryWithClassName:@"userRelation"];
    [queryToUserSecond whereKey:@"toUserId" equalTo:currentUserId];
    
    AVQuery* queryFromUserSecond = [AVQuery queryWithClassName:@"userRelation"];
    [queryFromUserSecond whereKey:@"fromUserId" equalTo:targetUserRelation.userObject.userId];

    
    AVQuery* queryPrimarySecond = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryToUserSecond,queryFromUserSecond,nil]];
    AVObject* secondRelation = [queryPrimarySecond getFirstObject];
    
    NSLog(@"firstRelation: %@", firstRelation.description);
    NSLog(@"secondRelation: %@", secondRelation.description);

    
    [firstRelation setObject:[NSNumber numberWithInt:0] forKey:@"userRelation"];
    [secondRelation setObject:[NSNumber numberWithInt:0] forKey:@"userRelation"];
    
    [firstRelation saveEventually];
    [secondRelation saveEventually];

    
    
    

}

@end
