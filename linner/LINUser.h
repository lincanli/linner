//
//  LINUser.h
//  Linner
//
//  Created by Lincan Li on 9/25/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LINUserData <NSObject>

@required

- (NSString *)userName;
- (UIImage *)userAvatar;
- (NSString *)userId;

@end


@interface LINUser : NSObject <LINUserData, NSCoding, NSCopying>

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) UIImage*  userAvatar;
@property (strong, nonatomic) NSString* userId;

@end
