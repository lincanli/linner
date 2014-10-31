//
//  LINAVUserRelation.m
//  Linner
//
//  Created by Lincan Li on 10/3/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAVUserRelation.h"

@implementation LINAVUserRelation

@dynamic toUserId, fromUserId, userRelation;

+ (NSString *)parseClassName {
    return @"userRelation";
}

@end
