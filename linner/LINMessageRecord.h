//
//  LINMessageRecord.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LINMessageRecord : NSManagedObject

@property (nonatomic) NSNumber* toUserId;
@property (nonatomic) NSNumber* messageType;

@property (nonatomic) NSString* messageListId;
@property (strong, nonatomic) NSString* messageText;
@property (strong, nonatomic) NSData* messageMedia;

@property (strong, nonatomic) NSDate* updatedAt;

@end
