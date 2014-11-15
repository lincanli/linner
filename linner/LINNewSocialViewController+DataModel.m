//
//  LINNewSocialViewController+DataModel.m
//  Linner
//
//  Created by Lincan Li on 11/14/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINNewSocialViewController+DataModel.h"
#import "LINSocialRecord.h"

@implementation LINNewSocialViewController (DataModel)

- (BOOL) saveNewSocial: (NSString *) content withBackgroundType: (NSNumber *) type andBackgroundImage: (UIImage *) image
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    AVUser* currentUser = [AVUser currentUser];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserObject" inManagedObjectContext:dataModel]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",[currentUser objectForKey:@"userId"]];
    [request setPredicate:predicate];
    
    LINUserObject *currentUserObject = [[dataModel executeFetchRequest:request error:&error] objectAtIndex:0];
    LINSocialRecord* socialRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SocialRecord" inManagedObjectContext:dataModel];
    
    socialRecord.content = content;
    socialRecord.backgroundType = type;
    
    if ([type isEqualToNumber:[NSNumber numberWithInt:1]]) {
        socialRecord.backgroundImage = UIImagePNGRepresentation([self imageWithImage:image scaledToSize:CGSizeMake(400, 400)]);
    }
    
    socialRecord.createdAt = [NSDate date];
    socialRecord.fromUserId = currentUserObject.userId;
    socialRecord.fromUserObject = currentUserObject;
    
    [dataModel save:&error];
    [self saveNewSocialToRemote:socialRecord];
    
    return YES;
}

- (void) saveNewSocialToRemote: (LINSocialRecord *) socialRecord
{
    LINAppDelegate *appDelegate = (LINAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* dataModel = appDelegate.managedObjectContext;
    NSError *error = nil;
    
    AVObject* socialObject = [AVObject objectWithClassName:@"socialRecord"];

    [socialObject setObject:socialRecord.content forKey:@"content"];
    [socialObject setObject:socialRecord.fromUserId forKey:@"fromUserId"];
    [socialObject setObject:socialRecord.backgroundType forKey:@"backgroundType"];
    
    if ([socialRecord.backgroundType isEqualToNumber:[NSNumber numberWithInt:1]]) {
        AVFile* imageFile = [AVFile fileWithName:@"image.png" data: socialRecord.backgroundImage];
        [imageFile saveInBackground];
        [socialObject setObject:imageFile forKey:@"backgroundImage"];
    }
    
    [socialObject save];
    [socialObject refresh];
    
    socialRecord.socialRecordId = [socialObject objectForKey:@"socialRecordId"];
    [dataModel save:&error];
}

#pragma image function

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
