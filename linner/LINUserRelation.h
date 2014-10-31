//
//  LINUserRelation.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LINUserRelation : NSManagedObject

@property (nonatomic) NSNumber*   toUserId;
@property (nonatomic) NSNumber*   userRelation;

@property (nonatomic) BOOL   sharePhoneNumber;

@property (nonatomic) BOOL   allowCallByApp;
@property (nonatomic) BOOL   allowCallByPhoneNumber;
@property (nonatomic) BOOL   relationActive;

@property (strong, nonatomic) NSDate*     updatedAt;

@property (strong, nonatomic) LINUserObject* userObject;

@end
