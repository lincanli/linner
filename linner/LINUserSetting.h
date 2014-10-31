//
//  LINUserSetting.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LINUserSetting : NSManagedObject

@property (nonatomic) NSNumber*   userId;

@property (nonatomic) NSNumber*   language;
@property (nonatomic) NSNumber*   pageInit;
@property (nonatomic) NSNumber*   fontSize;

@property (nonatomic) BOOL  requireValidation;
@property (nonatomic) BOOL  callViaLinner;
@property (nonatomic) BOOL  callViaNo;
@property (nonatomic) BOOL  friendRequestByEmail;
@property (nonatomic) BOOL  friendRequestById;
@property (nonatomic) BOOL  friendRequestByphoneNo;

@property (strong, nonatomic) NSDate*     updatedAt;

@end
