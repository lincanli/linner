//
//  LINProfileSettingDataHelper.m
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingDataHelper.h"

@implementation LINSettingDataHelper

- (void) saveForCurrentUser: (id)object forKey: (NSString *) key
{
    AVUser* currentUser = [AVUser currentUser];
    [currentUser setObject:object forKey:key];
    [currentUser saveEventually];
}

- (void) saveForUserInfo: (id)object forKey: (NSString *) key
{
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryUserInfo = [AVQuery queryWithClassName:@"userInfo"];
    [queryUserInfo whereKey:@"userId" equalTo:[currentUser objectForKey:@"userId" ]];
    AVObject* userInfo = [queryUserInfo getFirstObject];
    
    if (!userInfo)
        userInfo = [AVObject objectWithClassName:@"userInfo"];
    
    [userInfo setObject:[currentUser objectForKey:@"userId"] forKey:@"userId"];
    [userInfo setObject:object forKey:key];
    [userInfo saveEventually];
}

- (void) saveForUserSetting:(id)object forKey:(NSString *)key
{
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryUserInfo = [AVQuery queryWithClassName:@"userSetting"];
    [queryUserInfo whereKey:@"userId" equalTo:[currentUser objectForKey:@"userId" ]];
    AVObject* userSetting = [queryUserInfo getFirstObject];
    
    if (!userSetting)
        userSetting = [AVObject objectWithClassName:@"userSetting"];
    
    [userSetting setObject:[currentUser objectForKey:@"userId"] forKey:@"userId"];
    [userSetting setObject:object forKey:key];
    [userSetting saveEventually];
}

@end
