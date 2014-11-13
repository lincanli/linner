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
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
        [self setupUser:targetUser withTargetList:messageList];
        [self loadMessages];
    }
    
    return self;
}

- (void)setupUser: (LINUserObject *) targetUser withTargetList: (LINMessageList *) messageList
{
    AVUser* currentUser = [AVUser currentUser];
    self.targetUserObject = targetUser;
    self.messageList = messageList;
    
    self.userName = [[AVUser currentUser] objectForKey:@"name"];
    self.targetUserName = targetUser.userRealName;
    
    self.userId = [currentUser objectForKey:@"userId"];
    self.targetUserId = targetUser.userId;
}

- (void)loadMessages
{
    NSMutableArray* resultFromLocal = [self getInitData:self.targetUserObject messageList:self.messageList];
    self.messages = [[NSMutableArray alloc]init];

    if ([resultFromLocal count] == 0)
        return;
    
    for (LINMessageRecord* record in resultFromLocal) {
        
        if ([record.messageType isEqualToNumber:[NSNumber numberWithInt:0]]) {
            JSQMessage* aMessage;
            if ([record.toUserId isEqualToNumber:self.userId]) {
                NSLog(@"%@  %@", self.userId,  self.targetUserName);
                NSLog(@"%@  %@", record.updatedAt,  record.messageText);
                @try {
                    aMessage =[[JSQMessage alloc]  initWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                  senderDisplayName:self.userName
                                                               date:record.updatedAt
                                                               text:record.messageText];
                }
                @catch (NSException *exception) {
                    NSLog(@"error : %@", exception);
                }
                @finally {
                
                }

            } else {
                aMessage = [[JSQMessage alloc] initWithSenderId: [NSString stringWithFormat:@"%@", self.targetUserId]
                                                  senderDisplayName:self.targetUserName
                                                               date:record.updatedAt
                                                               text:record.messageText];
            }
            [self.messages addObject:aMessage];

        }else if ([record.messageType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            JSQPhotoMediaItem *aPhoto = [[JSQPhotoMediaItem alloc]initWithImage:[UIImage imageWithData:record.messageMedia]];
            JSQMessage* aMessage;

            if ([record.toUserId isEqualToNumber:self.userId]) {
                aMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                    displayName:self.userName
                                                          media:aPhoto];
            } else {
                aMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.targetUserId]
                                                    displayName:self.targetUserName
                                                          media:aPhoto];
            }
            [self.messages addObject:aMessage];
        
        }
        
    }
    
}

- (void)addPhotoMediaMessage
{
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                             displayName:self.userName
                                                                   media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                                displayName:self.userName
                                                                      media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.userId]
                                                             displayName:self.userName
                                                                   media:videoItem];
    [self.messages addObject:videoMessage];
}

@end