//
//  LINSettingTableViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/18/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSettingTableViewController+DataModel.h"
#import "LINUserSetting.h"

@implementation LINSettingTableViewController (DataModel)

#pragma userinfo data

- (id) getInitData: (NSString *) entity
{
    NSLog(@"getInitData - 1");
    AVUser* currentUser = [AVUser currentUser];
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", [currentUser objectForKey:@"userId"]];
    
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [dataModel executeFetchRequest:request error:&error];
    NSLog(@"error : %@ ", error);
    
    return [results objectAtIndex:0];
}

- (LINUserObject *) getUserInfoFromRemote
{
    NSLog(@"getUserInfoFromRemote - 1");
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryUserInfo = [AVQuery queryWithClassName:@"userInfo"];
    [queryUserInfo whereKey:@"userId" equalTo:[currentUser objectForKey:@"userId"]];
    
    AVObject* userInfo = [queryUserInfo getFirstObject];
    AVFile* imageFile = [userInfo objectForKey:@"userProfilePhoto"];
    NSData* imageData = [imageFile getData];
    UIImage *image= [UIImage imageWithData:imageData];
    
    
    [self storeRemoteToLocal:userInfo withProfilePhoto:image];
    
    NSLog(@"getUserInfoFromRemote - 2");
    return [self getInitData:@"UserObject"];
}

- (void) storeRemoteToLocal: (AVObject *) userInfo withProfilePhoto: (UIImage *)photo
{
    NSLog(@"storeRemoteToLocal - 1");
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", [userInfo objectForKey:@"userId" ]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [dataModel executeFetchRequest:request error:&error];
    NSLog(@"array desctiption, %@", results.description);
    
    LINUserObject *userObject = [results objectAtIndex:0];
    userObject.mainUser = YES;
    userObject.userId = [userInfo objectForKey:@"userId"];
    userObject.userName = [userInfo objectForKey:@"userName"];
    userObject.userRealName = [userInfo objectForKey:@"userRealName"];
    userObject.userNikeName = [userInfo objectForKey:@"userNikeName"];
    userObject.userEmail = [userInfo objectForKey:@"userEmail"];
    userObject.userSex = [userInfo objectForKey:@"userSex"];
    userObject.userDescription = [userInfo objectForKey:@"userDescription"];
    userObject.userBirthday = [userInfo objectForKey:@"userBirthday"];
    userObject.userLocation = [userInfo objectForKey:@"userLocation"];
    userObject.updatedAt = userInfo.updatedAt;
    userObject.userProfilePhoto = UIImagePNGRepresentation(photo);
    
    
    
    [dataModel save:&error];
    NSLog(@"storeRemoteToLocal - 2 error: %@", error);
    
}

#pragma usersetting data
- (LINUserSetting *) getUserSettingFromRemote
{
    NSLog(@"getUserInfoFromRemote - 1");
    AVUser* currentUser = [AVUser currentUser];
    
    AVQuery* queryUserInfo = [AVQuery queryWithClassName:@"userSetting"];
    [queryUserInfo whereKey:@"userId" equalTo:[currentUser objectForKey:@"userId"]];
    
    AVObject* userSetting = [queryUserInfo getFirstObject];
    [self storeRemoteToLocalUserSetting:userSetting];
    
    NSLog(@"getUserInfoFromRemote - 2");
    return [self getInitData:@"UserSetting"];
}

- (void) storeRemoteToLocalUserSetting: (AVObject *) quriedUserSetting
{
    NSLog(@"storeRemoteToLocalUserSetting - 1");
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserSetting" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", [quriedUserSetting objectForKey:@"userId" ]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [dataModel executeFetchRequest:request error:&error];
    NSLog(@"array desctiption, %@", results.description);
    
    // log error here
    LINUserSetting *userSetting = [results objectAtIndex:0];
    userSetting.userId = [quriedUserSetting objectForKey:@"userId"];
    userSetting.requireValidation = [[quriedUserSetting objectForKey:@"requireValidation"] boolValue];
    userSetting.callViaLinner = [[quriedUserSetting objectForKey:@"callViaLinner"] boolValue];
    userSetting.callViaNo = [[quriedUserSetting objectForKey:@"callViaNo"] boolValue];
    userSetting.fontSize = [quriedUserSetting objectForKey:@"fontSize"];
    userSetting.friendRequestByEmail = [[quriedUserSetting objectForKey:@"friendRequestByEmail"] boolValue];
    userSetting.friendRequestById = [[quriedUserSetting objectForKey:@"friendRequestById"] boolValue];
    userSetting.friendRequestByphoneNo = [[quriedUserSetting objectForKey:@"friendRequestByphoneNo"] boolValue];
    userSetting.language = [quriedUserSetting objectForKey:@"language"];
    userSetting.pageInit = [quriedUserSetting objectForKey:@"pageInit"];
    userSetting.updatedAt = quriedUserSetting.updatedAt;
    
    NSLog(@"description of newusersetting %@ ", userSetting.description);
    
    
    [dataModel save:&error];
    NSLog(@"storeRemoteToLocalUserSetting - 2 error: %@", error);
    
}


#pragma image function

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) saveImage: (UIImage*)Image
{
    AVUser* currentUser = [AVUser currentUser];
    
    UIImage *resizedImage = [self imageWithImage:Image scaledToSize:CGSizeMake(500, 500)];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    AVFile *imageFile = [AVFile fileWithName:@"userProfilePhoto.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        NSLog(@"error save : %@", error);
        
        [currentUser setObject:imageFile forKey:@"userProfilePhoto"];
        [currentUser saveEventually];
        
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        NSLog(@"upload percentage : %d", percentDone);
        
    }];
    
}


@end
