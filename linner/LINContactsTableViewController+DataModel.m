//
//  LINContactsTableCellTableViewCell+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/19/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINContactsTableViewController+DataModel.h"
#import "LINUserRelation.h"
#import "LINMessageList.h"
#import "LINUserSetting.h"

@implementation LINContactsTableViewController (DataModel)

-(NSMutableArray *) getInitData
{
    return [self getDataFromLocal];
}

-(NSMutableArray *) getDataFromLocal
{
    NSMutableArray* dataFromLocal;
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserRelation" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateRelationType = [NSPredicate predicateWithFormat:@"userRelation == %d", 1];
    [request setPredicate:predicateRelationType];
    
    NSPredicate *predicateRelationActive = [NSPredicate predicateWithFormat:@"relationActive == %@", [NSNumber numberWithBool: YES]];
    [request setPredicate:predicateRelationActive];
    
    NSError *error = nil;
    
    dataFromLocal = [NSMutableArray arrayWithArray:[dataModel executeFetchRequest:request error:&error]];

    NSLog(@"quired : %d", dataFromLocal.count);
    return dataFromLocal;
}

-(NSMutableArray *) getDataFromRemote
{
    NSMutableArray* dataFromRemote;
    AVUser* currentUser = [AVUser currentUser];
    [currentUser refresh];
    
    AVQuery *queryUser = [AVQuery queryWithClassName:@"userRelation"];
    [queryUser whereKey:@"fromUserId" equalTo:[currentUser objectForKey:@"userId"]];
    
//    AVQuery *queryRelation = [AVQuery queryWithClassName:@"userRelation"];
//    [queryRelation whereKey:@"userRelation" equalTo:[NSNumber numberWithInt:1]];
//    AVQuery* queryPrimary = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:queryUser, queryRelation, nil]];
    
    [queryUser includeKey:@"toUserObject.userInfo"];
    [queryUser includeKey:@"toUserObject.userSetting"];
    dataFromRemote = [NSMutableArray arrayWithArray:[queryUser findObjects]];
    
    NSLog(@"quried contact: %d", dataFromRemote.count);
    if ([dataFromRemote count] != 0)
        [self storeRemoteToLocal:dataFromRemote];
    
    return [self getDataFromLocal];
}



- (void) storeRemoteToLocal: (NSMutableArray*) remoteData
{
    [remoteData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"toUserId" ascending:YES]]];
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserRelation" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userRelation == %d", 1];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* resultArray = [dataModel executeFetchRequest:request error:&error];
    
    NSMutableArray* localData = [NSMutableArray arrayWithArray:resultArray];
    [localData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"toUserId" ascending:YES]]];
    
    NSMutableArray* tmpRemoteData = [NSMutableArray arrayWithArray:remoteData];
    NSMutableArray* tmpUpdateRemoteData = [NSMutableArray arrayWithArray:remoteData];
    NSMutableArray* toDeleteLocalData = [[NSMutableArray alloc]init];
    
    
    for (AVObject* userRelationRemote in remoteData) {
        for (LINUserRelation* userRelationLocal in localData) {
            
            if ([[userRelationRemote objectForKey:@"toUserId"] isEqualToNumber: userRelationLocal.toUserId] ){
            
                if ([[userRelationRemote objectForKey:@"userRelation"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    NSLog(@"userId %@", [userRelationRemote objectForKey:@"toUserId"]);
                    
                    [toDeleteLocalData addObject:userRelationLocal];
                    NSLog(@"remove object@!");
                    [tmpUpdateRemoteData removeObjectIdenticalTo:userRelationRemote];
                }

                [tmpRemoteData removeObjectIdenticalTo:userRelationRemote];

            }

        }
    }
    

    
    for (AVObject* userRelationRemote in tmpRemoteData) {
        NSLog(@"userIddd %@", [userRelationRemote objectForKey:@"toUserId"]);

        
        AVObject* userObjectRemote = [userRelationRemote objectForKey:@"toUserObject"];
        LINUserRelation* newUserRelationLocal = [NSEntityDescription insertNewObjectForEntityForName:@"UserRelation" inManagedObjectContext:dataModel];
        LINUserObject* newUserObjectLocal = [self returnUserObject:userObjectRemote];
        LINUserSetting* newUserSettingLocal = [self returnUserSetting:userObjectRemote];
        
        newUserSettingLocal = [self updateUserSetting:newUserSettingLocal fromRemoteData:userRelationRemote];
        newUserObjectLocal = [self updateUserObject:newUserObjectLocal andUserSetting:newUserSettingLocal fromRemoteData:userObjectRemote];
        newUserRelationLocal = [self updateUserRelation:newUserRelationLocal andUserObject:newUserObjectLocal fromRemoteData:userRelationRemote];
        
        [dataModel save:&error];
        [tmpUpdateRemoteData removeObjectIdenticalTo:userRelationRemote];
    }
    
    for (LINUserRelation* oldUserRelation in toDeleteLocalData) {
        NSLog(@"userIdd %@", oldUserRelation.toUserId);

        oldUserRelation.relationActive = NO;
        LINUserObject* oldUserObject = oldUserRelation.userObject;
        oldUserObject.userActive = NO;
        
        [dataModel save:&error];
        [localData removeObjectIdenticalTo:oldUserRelation];
    }
    
    [tmpUpdateRemoteData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"toUserId" ascending:YES]]];
    [localData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"toUserId" ascending:YES]]];

    NSLog(@"noerror!!!!!!!!!!!!!! %d, %d", tmpUpdateRemoteData.count, localData.count);

    if (tmpUpdateRemoteData.count != localData.count) {
        NSLog(@"error!!!!!!!!!!!!!! %d, %d", tmpUpdateRemoteData.count, localData.count);
    }
    
    for (int i = 0; i < tmpUpdateRemoteData.count; i++) {
        AVObject* userRelationRemote = [tmpUpdateRemoteData objectAtIndex:i];
        AVObject* userObjectRemote = [userRelationRemote objectForKey:@"toUserObject"];
        
        LINUserRelation* oldUserRelationLocal = [localData objectAtIndex:i];
        LINUserObject* oldUserObjectLocal = oldUserRelationLocal.userObject;
        LINUserSetting* oldUserSettingLocal = oldUserObjectLocal.userSetting;
        
        oldUserSettingLocal = [self updateUserSetting:oldUserSettingLocal fromRemoteData:userRelationRemote];
        oldUserObjectLocal = [self updateUserObject:oldUserObjectLocal andUserSetting:oldUserSettingLocal fromRemoteData:userObjectRemote];
        oldUserRelationLocal = [self updateUserRelation:oldUserRelationLocal andUserObject:oldUserObjectLocal fromRemoteData:userRelationRemote];
    }
    
    
    
}

-(LINUserSetting *) updateUserSetting: (LINUserSetting *) userSetting fromRemoteData: (AVObject *) remoteData
{
    AVObject* userSettingRemote = [remoteData objectForKey:@"userSetting"];
    
    userSetting.userId = [userSettingRemote objectForKey:@"userId"];
    userSetting.requireValidation = [[userSettingRemote objectForKey:@"requireValidation"] boolValue];
    userSetting.callViaLinner = [[userSettingRemote objectForKey:@"callViaLinner"] boolValue];
    userSetting.callViaNo = [[userSettingRemote objectForKey:@"callViaNo"] boolValue];
    userSetting.fontSize = [userSettingRemote objectForKey:@"fontSize"];
    userSetting.friendRequestByEmail = [[userSettingRemote objectForKey:@"friendRequestByEmail"] boolValue];
    userSetting.friendRequestById = [[userSettingRemote objectForKey:@"friendRequestById"] boolValue];
    userSetting.friendRequestByphoneNo = [[userSettingRemote objectForKey:@"friendRequestByphoneNo"] boolValue];
    userSetting.language = [userSettingRemote objectForKey:@"language"];
    userSetting.pageInit = [userSettingRemote objectForKey:@"pageInit"];
    userSetting.updatedAt = userSettingRemote.updatedAt;
    
    return userSetting;
}


-(LINUserObject *) updateUserObject: (LINUserObject *) userObject andUserSetting: (LINUserSetting *) userSetting fromRemoteData: (AVObject *) remoteData
{
    AVObject* userInfo = [remoteData objectForKey:@"userInfo"];
    userObject.mainUser = NO;
    userObject.userId = [userInfo objectForKey:@"userId"];
    userObject.userEmail = [userInfo objectForKey:@"userEmail"];
    userObject.userRealName = [userInfo objectForKey:@"userRealName"];
    userObject.userDescription = [userInfo objectForKey:@"userDescription"];
    userObject.userSex = [userInfo objectForKey:@"userSex"];
    userObject.userBirthday = [userInfo objectForKey:@"userBirthday"];
    userObject.userLocation = [userInfo objectForKey:@"userLocation"];
    userObject.userNikeName = [userInfo objectForKey:@"userNikeName"];
    userObject.userSetting = userSetting;
    
    AVFile* profilePhotoFile = [remoteData objectForKey:@"userProfilePhoto"];
    if (profilePhotoFile != nil) {
        [profilePhotoFile getDataInBackgroundWithBlock:^(NSData* data, NSError* error){
            
        }];
    }
    
    return userObject;
}

-(LINUserRelation *) updateUserRelation: (LINUserRelation *) userRelation andUserObject: (LINUserObject *) userObject  fromRemoteData: (AVObject *) remoteData
{
    userRelation.toUserId = [remoteData objectForKey:@"toUserId"];
    userRelation.userRelation = [remoteData objectForKey:@"userRelation"];
    userRelation.allowCallByApp = [[remoteData objectForKey:@"allowCallByApp"] boolValue];
    userRelation.allowCallByPhoneNumber = [[remoteData objectForKey:@"allowCallByPhoneNumber"] boolValue];
    userRelation.sharePhoneNumber = [[remoteData objectForKey:@"sharePhoneNumber"] boolValue];
    
    
    userRelation.updatedAt = remoteData.updatedAt;
    userRelation.userObject = userObject;
    
    if ([[remoteData objectForKey:@"userRelation"] isEqualToNumber: [NSNumber numberWithInt:0]]) {
        userRelation.relationActive = NO;
        userRelation.userObject.userActive = NO;
    }else{
        userRelation.relationActive = YES;
        userRelation.userObject.userActive = YES;
    }
    
    return userRelation;
}

-(LINUserObject *) returnUserObject: (AVObject *) remoteData
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %d", [remoteData objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    NSArray* dataFromLocal = [dataModel executeFetchRequest:request error:&error];
    if (dataFromLocal.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:@"UserObject" inManagedObjectContext:dataModel];
    }else{
        return [dataFromLocal objectAtIndex:0];
    }
}

-(LINUserSetting *) returnUserSetting: (AVObject *) remoteData
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError* error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserSetting" inManagedObjectContext:dataModel];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %d", [remoteData objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    NSArray* dataFromLocal = [dataModel executeFetchRequest:request error:&error];
    if (dataFromLocal.count == 0) {
        return [NSEntityDescription insertNewObjectForEntityForName:@"UserSetting" inManagedObjectContext:dataModel];
    }else{
        return [dataFromLocal objectAtIndex:0];
    }
}

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
