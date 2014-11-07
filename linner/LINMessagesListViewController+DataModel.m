//
//  LINMessagesListViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 10/24/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINMessagesListViewController+DataModel.h"

@implementation LINMessagesListViewController (DataModel)

- (NSString *) returnJsonEncryption: (NSMutableDictionary *) rawData
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:rawData options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"error : %@", error);
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (NSMutableDictionary *) returnJsonDncryption: (NSString *) rawData
{
    NSData* jsonData = [rawData dataUsingEncoding:NSUTF8StringEncoding];
    return [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil]];
}

- (void) storeForSelfToLocal:(NSMutableDictionary *) rawData  withMessageList: (LINMessageList *) messageList withMessageType: (NSNumber *) messageType
{
    AVUser* currentUser = [AVUser currentUser];
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", [currentUser objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [dataModel executeFetchRequest:request error:&error];
    LINUserObject* user = [results objectAtIndex:0];
    
    if ([messageType isEqualToNumber:[NSNumber numberWithInt:0]])
        [self storeToLocal:rawData withTargetUser:user withMessageList:messageList];
    else if ([messageType isEqualToNumber:[NSNumber numberWithInt:1]])
        [self storeImageToLocal:rawData withTargetUser:user withMessageList:messageList];
}

- (void) storeToLocal: (NSMutableDictionary *) rawData withTargetUser: (LINUserObject *) targetUser withMessageList: (LINMessageList *) messageList
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    LINMessageRecord* messageRecord = [NSEntityDescription insertNewObjectForEntityForName:@"MessageRecord" inManagedObjectContext:dataModel];
    
    messageRecord.toUserId = targetUser.userId;
    messageRecord.messageType = [rawData objectForKey:@"type"];
    NSLog(@"content %@", [rawData objectForKey:@"content"]);
    if ([[rawData objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        messageRecord.messageText = [rawData objectForKey:@"content"];
    }
    messageRecord.messageListId = [NSString stringWithFormat:@"%@", [messageList.objectID URIRepresentation]];
    NSLog(@"messageListId: %@", [messageRecord.objectID URIRepresentation] );
    messageRecord.updatedAt = [NSDate date];

    [dataModel save:&error];
    
    [self updateMessageList:messageList withMessageRecord:messageRecord];
}

- (void) storeImageToLocal: (NSMutableDictionary *) rawData withTargetUser: (LINUserObject *) targetUser withMessageList: (LINMessageList *) messageList
{
    NSData *imageData = UIImagePNGRepresentation([rawData objectForKey:@"messageMedia"]);
    
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    LINMessageRecord* messageRecord = [NSEntityDescription insertNewObjectForEntityForName:@"MessageRecord" inManagedObjectContext:dataModel];
    
    messageRecord.toUserId = targetUser.userId;
    messageRecord.messageMedia = imageData;
    messageRecord.messageType = [rawData objectForKey:@"type"];
    
    messageRecord.messageListId = [NSString stringWithFormat:@"%@", [messageList.objectID URIRepresentation]];
    NSLog(@"messageListId: %@", [messageRecord.objectID URIRepresentation] );
    messageRecord.updatedAt = [NSDate date];
    
    [dataModel save:&error];
    
    [self updateMessageList:messageList withMessageRecord:messageRecord];
}


- (void) updateMessageList: (LINMessageList *) messageList withMessageRecord: (LINMessageRecord *)messageRecord
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    if ([messageRecord.messageType isEqualToNumber:[NSNumber numberWithInt:0]])
        messageList.messageContent = messageRecord.messageText;
    else if ([messageRecord.messageType isEqualToNumber:[NSNumber numberWithInt:1]])
        messageList.messageContent = @"[图片]";
    
    messageList.updatedAt = [NSDate date];
    
    [dataModel save:&error];
}


#pragma image function
- (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(int)newWidth
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    CGSize newSize = CGSizeMake(newWidth, image.size.height * newWidth/image.size.width);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
