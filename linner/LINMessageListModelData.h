//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "JSQMessages.h"

#import "LINMessageList.h"
#import "LINMessageRecord.h"


@interface LINMessageListModelData : NSObject

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSDictionary *users;

@property (strong, nonatomic) LINMessageList* messageList;
@property (strong, nonatomic) LINUserObject* targetUserObject;

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* targetUserName;

@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* targetUserId;

@property (strong, nonatomic) JSQMessagesAvatarImage* userAvatar;
@property (strong, nonatomic) JSQMessagesAvatarImage* targetUserAvatar;

- (instancetype)init: (LINUserObject *) targetUser withTargetList: (LINMessageList *) messageList;

- (void)addPhotoMediaMessage;
- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion;
- (void)addVideoMediaMessage;

@end