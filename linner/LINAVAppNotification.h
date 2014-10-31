//
//  LINAVAppNotification.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LINAVAppNotification : AVObject <AVSubclassing>

@property (nonatomic) NSNumber* toUserId;
@property (nonatomic) NSNumber* fromUserId;

@property (strong, nonatomic) NSString* notificationContent;

@property (nonatomic) NSNumber* read;
@property (nonatomic) NSNumber* acted;

@end
