//
//  LINSocialRecord.h
//  Linner
//
//  Created by Lincan Li on 11/14/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LINSocialRecord : NSManagedObject

@property (nonatomic) NSNumber* fromUserId;
@property (nonatomic) NSNumber* socialRecordId;

@property (nonatomic) NSNumber* backgroundType;
@property (nonatomic) NSData* backgroundImage;

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSDate* createdAt;

@property (strong, nonatomic) LINUserObject* fromUserObject;

@end
