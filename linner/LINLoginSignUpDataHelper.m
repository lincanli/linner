//
//  LINLoginSignUpDataHelper.m
//  Linner
//
//  Created by Lincan Li on 10/19/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINLoginSignUpDataHelper.h"
#import "LINUserObject.h"
#import "LINUserSetting.h"

@implementation LINLoginSignUpDataHelper

- (BOOL) saveForUserObject: (NSString *) currentUserName signUp: (BOOL) signUp
{
    // The find succeeded.
    NSLog(@"Phase Login - reteriving user data no error");
    NSLog(@"Phase Login - Init datamodel");
    
//    AVQuery* queryUser = [AVUser query];
//    [queryUser whereKey:@"username" equalTo:user.username];
//    AVObject* currentUser = [queryUser getFirstObject];

    AVUser* currentUserObject = [AVUser currentUser];
    [currentUserObject refresh];
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    LINUserObject* userObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserObject" inManagedObjectContext:dataModel];
    NSError* dataModelSaveError = nil;
    
    userObject.userId = [NSNumber numberWithInt:[[currentUserObject objectForKey:@"userId"]intValue]];
    userObject.userName = currentUserObject.username;
    userObject.userRealName = [currentUserObject objectForKey:@"name"];
    userObject.userEmail = currentUserObject.email;
    userObject.updatedAt = currentUserObject.updatedAt;
    userObject.mainUser = YES;
    
    if (signUp) {
        AVObject* currentUserInfo = [AVObject objectWithClassName:@"userInfo"];
        [currentUserInfo setObject:[currentUserObject objectForKey:@"userId"] forKey:@"userId"];
        [currentUserInfo setObject:userObject.userEmail forKey:@"userEmail"];
        [currentUserInfo setObject:userObject.userRealName forKey:@"userRealName"];
        
        AVObject* currentUserSetting = [AVObject objectWithClassName:@"userSetting"];
        [currentUserSetting setObject:[currentUserObject objectForKey:@"userId"] forKey:@"userId"];

        [currentUserObject setObject:currentUserInfo forKey:@"userInfo"];
        [currentUserObject setObject:currentUserSetting forKey:@"userSetting"];
        [currentUserObject save];
    }
    
    [currentUserObject setObject:appDelegate.installationID forKey:@"installationID"];
    [currentUserObject save];
    
    if(![dataModel save:&dataModelSaveError]){
        NSLog(@"Phase Login - saving user data error:%@", [dataModelSaveError localizedDescription]);
        return NO;
    }else{
        
        [self saveForUserSetting:currentUserObject];
        [self saveForUserInfo:currentUserObject withUserObject:userObject];
        return YES;
    }

}

- (void) saveForUserSetting: (AVObject *) object
{
    AVObject* aUserSetting = [object objectForKey:@"userSetting"];
    AVObject* currentUserSetting = [aUserSetting fetchIfNeeded];
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    LINUserSetting* userSetting = [NSEntityDescription insertNewObjectForEntityForName:@"UserSetting" inManagedObjectContext:dataModel];
    NSError* dataModelSaveError = nil;
    
    NSLog(@"saveForUserSetting %@", object.description);
    
    userSetting.userId = [currentUserSetting objectForKey:@"userId"];
    userSetting.requireValidation = [[currentUserSetting objectForKey:@"requireValidation"] boolValue];
    userSetting.callViaLinner = [[currentUserSetting objectForKey:@"callViaLinner"] boolValue];
    userSetting.callViaNo = [[currentUserSetting objectForKey:@"callViaNo"] boolValue];
    userSetting.fontSize = [currentUserSetting objectForKey:@"fontSize"];
    userSetting.friendRequestByEmail = [[currentUserSetting objectForKey:@"friendRequestByEmail"] boolValue];
    userSetting.friendRequestById = [[currentUserSetting objectForKey:@"friendRequestById"] boolValue];
    userSetting.friendRequestByphoneNo = [[currentUserSetting objectForKey:@"friendRequestByphoneNo"] boolValue];
    userSetting.language = [currentUserSetting objectForKey:@"language"];
    userSetting.pageInit = [currentUserSetting objectForKey:@"pageInit"];
    userSetting.updatedAt = currentUserSetting.updatedAt;

    [dataModel save:&dataModelSaveError];
    NSLog(@"saveForUserSetting error %@", dataModelSaveError);

}

- (void) saveForUserInfo: (AVObject *) object withUserObject: (LINUserObject *) userObject
{
    AVObject* aUserInfo = [object objectForKey:@"userInfo"];
    AVObject* currentUserInfo = [aUserInfo fetchIfNeeded];
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* dataModelSaveError = nil;
    
    userObject.mainUser = YES;
    userObject.userId = [currentUserInfo objectForKey:@"userId"];
    userObject.userRealName = [currentUserInfo objectForKey:@"userRealName"];
    userObject.userNikeName = [currentUserInfo objectForKey:@"userNikeName"];
    userObject.userEmail = [currentUserInfo objectForKey:@"userEmail"];
    userObject.userSex = [currentUserInfo objectForKey:@"userSex"];
    userObject.userDescription = [currentUserInfo objectForKey:@"userDescription"];
    userObject.userBirthday = [currentUserInfo objectForKey:@"userBirthday"];
    userObject.userLocation = [currentUserInfo objectForKey:@"userLocation"];
    userObject.updatedAt = currentUserInfo.updatedAt;
    
    [dataModel save:&dataModelSaveError];
    
}


@end
