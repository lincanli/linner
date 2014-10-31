//
//  LINAVAppNotification.m
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAVAppNotification.h"

@implementation LINAVAppNotification

@dynamic toUserId, fromUserId, notificationContent, read, acted;

+ (NSString *)parseClassName {
    return @"appNotification";
}

@end
