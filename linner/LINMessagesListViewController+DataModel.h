//
//  LINMessagesListViewController+DataModel.h
//  Linner
//
//  Created by Lincan Li on 10/24/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINMessagesListViewController.h"
#import "LINMessageRecord.h"

@interface LINMessagesListViewController (DataModel)

- (NSString *) returnJsonEncryption: (NSDictionary *) rawData;
- (NSMutableDictionary *) returnJsonDncryption: (NSString *) rawData;

- (void) storeToLocal: (NSMutableDictionary *) rawData withTargetUser: (LINUserObject *) targetUser withMessageList: (LINMessageList *) messageList;
- (void) storeForSelfToLocal:(NSMutableDictionary *) rawData  withMessageList: (LINMessageList *) messageList withMessageType: (NSNumber *) messageType;
- (void) storeImageToLocal: (NSMutableDictionary *) rawData withTargetUser: (LINUserObject *) targetUser withMessageList: (LINMessageList *) messageList;

- (UIImage *)imageWithImage:(UIImage *)image scaledToWidth:(int)newWidth;

@end
