//
//  LINAVUserRelation.h
//  Linner
//
//  Created by Lincan Li on 10/3/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LINAVUserRelation : AVObject <AVSubclassing>

@property (nonatomic) NSNumber* toUserId;
@property (nonatomic) NSNumber* fromUserId;

@property (nonatomic) NSNumber* userRelation;


@end
