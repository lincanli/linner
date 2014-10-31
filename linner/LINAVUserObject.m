//
//  LINAVUserObject.m
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAVUserObject.h"

@implementation LINAVUserObject

@dynamic userId, name, userRealName, userProfilePhoto;

+ (NSString *)parseClassName {
    return @"_User";
}

@end
