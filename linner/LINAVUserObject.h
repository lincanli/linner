//
//  LINAVUserObject.h
//  Linner
//
//  Created by Lincan Li on 10/2/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface LINAVUserObject : AVUser <AVSubclassing>

@property (nonatomic) NSNumber* userId;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* userRealName;
@property (strong, nonatomic) NSString* userProfilePhoto;

@end
