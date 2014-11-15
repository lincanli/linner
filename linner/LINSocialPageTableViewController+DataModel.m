//
//  LINSocialPageTableViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 11/14/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINSocialPageTableViewController+DataModel.h"
#import "LINSocialRecord.h"

@implementation LINSocialPageTableViewController (DataModel)

- (NSMutableArray *) getInitData
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SocialRecord" inManagedObjectContext:dataModel]];
    
    [request setFetchLimit:30];
    
    return [NSMutableArray arrayWithArray:[dataModel executeFetchRequest:request error:&error]];
}

- (NSMutableArray *) getDataFromRemote
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    AVUser* currentUser = [AVUser currentUser];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId != %@",[currentUser objectForKey:@"userId"]];
    [request setPredicate:predicate];

    NSArray* friendsId = [dataModel executeFetchRequest:request error:&error];
    
    if ([friendsId count] == 0) {
        NSLog(@"nbo objs");
        return nil;
    }
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SocialRecord" inManagedObjectContext:dataModel]];
    
    predicate = [NSPredicate predicateWithFormat:@"fromUserId != %@",[currentUser objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    NSMutableArray* lastRecordArray = [NSMutableArray arrayWithArray:[dataModel executeFetchRequest:request error:&error]];
    NSNumber* lastRecordId;
    
    if ([lastRecordArray count] == 0) {
        lastRecordId = [NSNumber numberWithInt:0];
    }else{
        [lastRecordArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fromUserId" ascending:NO]]];

        LINSocialRecord* mySocialRecord = [lastRecordArray firstObject];
        lastRecordId = mySocialRecord.socialRecordId;
    }
    
    NSLog(@"lastRecordId : %@", lastRecordId);

    
    NSMutableArray* userIds = [[NSMutableArray alloc]init];
    
    for (LINUserObject* userObject in friendsId) {
        [userIds addObject:userObject.userId];
    }
    
    AVQuery* socialQuery = [AVQuery queryWithClassName:@"socialRecord"];
    [socialQuery whereKey:@"fromUserId" containedIn:userIds];
    [socialQuery whereKey:@"socialRecordId" greaterThan:lastRecordId];
    socialQuery.limit = 20;
    
    [self saveNewSocial:[socialQuery findObjects:&error]];
    NSLog(@"error : %@", error);
    
    return [self getInitData];
}

- (void) saveNewSocial: (NSArray *) socialObjectArray
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    for (AVObject* socialObject in socialObjectArray) {
        LINSocialRecord* socialRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SocialRecord" inManagedObjectContext:dataModel];
        
        socialRecord.content = [socialObject objectForKey:@"content"];
        socialRecord.backgroundType = [socialObject objectForKey:@"backgroundType"];
        
        
        if ([socialRecord.backgroundType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            AVFile* profilePhotoFile = [socialObject objectForKey:@"backgroundImage"];
            socialRecord.backgroundImage = [profilePhotoFile getData];
        }
        
        socialRecord.createdAt = socialObject.createdAt;
        socialRecord.fromUserId = [socialObject objectForKey:@"fromUserId"];
        socialRecord.socialRecordId = [socialObject objectForKey:@"socialRecordId"];

        socialRecord.fromUserObject = [self returnUserObject:[socialObject objectForKey:@"fromUserId"]];
        [dataModel save:&error];
    }
}




- (LINUserObject *) returnSelf
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    AVUser* currentUser = [AVUser currentUser];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",[currentUser objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    return [[dataModel executeFetchRequest:request error:&error] objectAtIndex:0];
}

- (LINUserObject *) returnUserObject: (NSNumber *) userId
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    [request setPredicate:predicate];
    
    return [[dataModel executeFetchRequest:request error:&error] objectAtIndex:0];
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

@end
