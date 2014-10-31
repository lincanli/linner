//
//  LINMessageList.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LINUserRelation.h"

@interface LINMessageList : NSManagedObject

@property (nonatomic) NSNumber*   toUserId;
@property (nonatomic) NSNumber*   messageListId;
@property (nonatomic) NSNumber*   NewNo;

@property (strong, nonatomic) NSString*   messageContent;

@property (nonatomic) BOOL   read;
@property (nonatomic) BOOL   topRank;
@property (nonatomic) BOOL   enableNoti;

@property (strong, nonatomic) LINUserRelation* targetUserRelation;
@property (strong, nonatomic) LINUserObject* targetUserObject;

@property (strong, nonatomic) NSDate*     updatedAt;

@end
