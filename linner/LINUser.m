//
//  LINUser.m
//  Linner
//
//  Created by Lincan Li on 9/25/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINUser.h"

@implementation LINUser

+ (instancetype)userInitWithUserName:(NSString *)userName userAvatar:(UIImage *)userAvatar userId:(NSString *)userId
{
    return [[LINUser alloc]initWithUserName:userName userAvatar:userAvatar userId:userId];
}

- (instancetype)initWithUserName:(NSString *)userName
                           userAvatar:(UIImage *)userAvatar
                              userId:(NSString *)userId
{
    NSLog(@"Message Class - Assertion");
    NSParameterAssert(userName != nil);
    NSParameterAssert(userAvatar != nil);
    NSParameterAssert(userId != nil);
    
    NSLog(@"Message Class - init class");
    self = [self init];
    if (self) {
        _userName = userName;
        _userAvatar = userAvatar;
        _userId = userId;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    NSLog(@"Message Class - initclass without text");
    if (self) {
        _userName = @"";
        _userAvatar = [UIImage alloc];
        _userId = @"";
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Message Class - dealloc");
    _userName = nil;
    _userAvatar = nil;
    _userId = nil;
}

#pragma mark - JSQMessage

- (BOOL)isEqualToMessage:(LINUser *)aUser
{
    NSLog(@"Message Class - ifequaltomessage");
    return self.userAvatar == aUser.userAvatar
    && [self.userName isEqualToString:aUser.userName]
    && [self.userId isEqualToString:aUser.userId];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    NSLog(@"Message Class - return is equal");
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToMessage:(LINUser *)object];
}

- (NSUInteger)hash
{
    NSLog(@"Message Class - calculate hash code");
    return [self.userAvatar hash] ^ [self.userId hash] ^ [self.userName hash];
}

- (NSString *)description
{
    NSLog(@"Message Class - log out descripiton");
    return [NSString stringWithFormat:@"<%@>[ %@, %@, %@]", [self class], self.userAvatar, self.userId, self.userName];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"Message Class - decode objects");
    self = [super init];
    if (self) {
        _userName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userName))];
        _userAvatar = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userAvatar))];
        _userId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userId))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"Message Class - decode objects");
    [aCoder encodeObject:self.userName forKey:NSStringFromSelector(@selector(userName))];
    [aCoder encodeObject:self.userAvatar forKey:NSStringFromSelector(@selector(userAvatar))];
    [aCoder encodeObject:self.userId forKey:NSStringFromSelector(@selector(userId))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    NSLog(@"Message Class - copy objective with zone");
    return [[[self class] allocWithZone:zone]initWithUserName:self.userName userAvatar:self.userAvatar userId:self.userId];
            
}


@end
