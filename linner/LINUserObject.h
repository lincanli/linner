//
//  LINUserObject.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LINUserSetting.h"

@interface LINUserObject : NSManagedObject

@property (nonatomic) NSNumber*   userId;

@property (nonatomic) NSString*   userSex;
@property (strong, nonatomic) NSString*   userEmail;
@property (strong, nonatomic) NSString*   userName;
@property (strong, nonatomic) NSString*   userNikeName;
@property (strong, nonatomic) NSString*   userRealName;
@property (strong, nonatomic) NSString*   userDescription;
@property (strong, nonatomic) NSString*   userLocation;
@property (strong, nonatomic) NSString*   userProfilePhotoObjectId;

@property (nonatomic) BOOL mainUser;
@property (nonatomic) BOOL userActive;

@property (strong, nonatomic) NSData*  userProfilePhoto;

@property (strong, nonatomic) NSDate*     userBirthday;
@property (strong, nonatomic) NSDate*     updatedAt;


@property (strong, nonatomic) LINUserSetting* userSetting;

@end
