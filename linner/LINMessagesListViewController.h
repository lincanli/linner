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


// Import all the things
#import "JSQMessages.h"

#import "LINMessageListModelData.h"
#import "LINMessageList.h"
#import "LINUserRelation.h"

@class LINMessagesListViewController;

@protocol LINMessagesListViewController <NSObject>

@end

@interface LINMessagesListViewController : JSQMessagesViewController <UIActionSheetDelegate, AVSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id<LINMessagesListViewController> delegateModal;
@property (strong, nonatomic) LINMessageListModelData *messageListData;
@property (strong, nonatomic) LINMessageList* messageList;
@property (strong, nonatomic) LINUserRelation* targetRelation;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;
- (void)closePressed:(UIBarButtonItem *)sender;
// TODO: example of async avatar loading

@end
