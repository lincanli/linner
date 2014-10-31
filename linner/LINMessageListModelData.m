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

#import "LINMessageListModelData.h"
#import "LINMessageListModelData+DataModel.h"

@interface LINMessageListModelData ()

@end

@implementation LINMessageListModelData

- (instancetype)init: (LINUserObject *) targetUser withTargetList: (LINMessageList *) messageList
{
    self = [super init];
    if (self) {
        
        AVUser* currentUser = [AVUser currentUser];
        self.targetUserObject = targetUser;
        self.messageList = messageList;
        
        self.userName = [[AVUser currentUser] objectForKey:@"name"];
        self.targetUserName = targetUser.userRealName;
        
        self.userId = [currentUser objectForKey:@"userId"];
        self.targetUserId = targetUser.userId;
        
        [self loadMessages];
        
//        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JSQ"
//                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
//                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
//                                                                                                 font:[UIFont systemFontOfSize:14.0f]
//                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.userAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.targetUserAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];


        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void)loadMessages
{    
    NSMutableArray* resultFromLocal = [self getInitData:self.targetUserObject messageList:self.messageList];
    self.messages = [[NSMutableArray alloc]init];

    if ([resultFromLocal count] == 0)
        return;
    
    
    self.messages = [[NSMutableArray alloc]init];
    
    for (LINMessageRecord* record in resultFromLocal) {
        JSQTextMessage* aMessage;
        if ([record.toUserId isEqualToNumber:self.userId]) {
            NSLog(@"description , %@", record.description);
            NSLog(@"23");
            aMessage = [[JSQTextMessage alloc] initWithSenderId: [NSString stringWithFormat:@"%@", self.userId]
                                                             senderDisplayName:self.userName
                                                                          date:record.updatedAt
                                                                          text:record.messageText];
        } else {
            NSLog(@"description , %@", record.description);
            NSLog(@"23");
            aMessage = [[JSQTextMessage alloc] initWithSenderId: [NSString stringWithFormat:@"%@", self.targetUserId]
                                              senderDisplayName:self.targetUserName
                                                           date:record.updatedAt
                                                           text:record.messageText];
        
        }
        
        [self.messages addObject:aMessage];
    }
    
    
    [self addPhotoMediaMessage];
    
}

- (void)addPhotoMediaMessage
{
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMediaMessage *photoMessage = [JSQMediaMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                             displayName:self.userName
                                                                   media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMediaMessage *locationMessage = [JSQMediaMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                                displayName:self.userName
                                                                      media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMediaMessage *videoMessage = [JSQMediaMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                             displayName:self.userName
                                                                   media:videoItem];
    [self.messages addObject:videoMessage];
}

@end