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

#import "LINMessagesListViewController.h"
#import "LINMessagesListViewController+DataModel.h"
#import "LINProfileTableViewControllerPointToPoint.h"

#import "AHKActionSheet.h"
@interface LINMessagesListViewController()
@property (strong, nonatomic) LINUserObject* targetUser;
@end

@implementation LINMessagesListViewController
AVSession* messageSession;
AVUser* currentUser;
UIImage* tmpImage = nil;

#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.targetUser = self.targetRelation.userObject;
    self.title = self.targetUser.userRealName;
    
    /**
     *  Load up our fake data for the demo
     */
    self.messageListData = [[LINMessageListModelData alloc]init:self.targetUser withTargetList:self.messageList];
    
    self.senderId = [NSString stringWithFormat:@"%@", self.messageListData.userId];
    self.senderDisplayName = self.messageListData.userName;
    
    /**
     *  You can set custom avatar sizes
     */
    
    self.showLoadEarlierMessagesHeader = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(profileForPointToPoint:)];
    
    currentUser = [AVUser currentUser];
    messageSession =  [[AVSession alloc] init];
    messageSession.sessionDelegate = self;
    NSLog(@"current user id %@", [currentUser objectForKey:@"userId"]);
    NSLog(@"targertUser user id %@", self.targetUser.userId);
    NSString* currentUserIdInString = [NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]];
    NSString* targetUserIdInString = [NSString stringWithFormat:@"%@", self.targetUser.userId];

    [messageSession openWithPeerId:currentUserIdInString watchedPeerIds:@[targetUserIdInString]];

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}



#pragma mark - Actions

- (void)profileForPointToPoint:(UIBarButtonItem *)sender
{
    
    LINProfileTableViewControllerPointToPoint* profileForPointToPoint = [[LINProfileTableViewControllerPointToPoint alloc]init];
    profileForPointToPoint.targetUserRelation = self.targetRelation;
    profileForPointToPoint.messageList = self.messageList;
    [self showViewController:profileForPointToPoint sender:nil];
    
    
    
//    /**
//     *  DEMO ONLY
//     *
//     *  The following is simply to simulate received messages for the demo.
//     *  Do not actually do this.
//     */
//    
//    
//    /**
//     *  Show the typing indicator to be shown
//     */
//    self.showTypingIndicator = !self.showTypingIndicator;
//    
//    /**
//     *  Scroll to actually view the indicator
//     */
//    [self scrollToBottomAnimated:YES];
//    
//    /**
//     *  Copy last sent message, this will be the new "received" message
//     */
//    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
//    
//    if (!copyMessage) {
//        copyMessage = [JSQTextMessage messageWithSenderId:kJSQDemoAvatarIdJobs
//                                              displayName:kJSQDemoAvatarDisplayNameJobs
//                                                     text:@"First received!"];
//    }
//    
//    /**
//     *  Allow typing indicator to show
//     */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
//        [userIds removeObject:self.senderId];
//        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
//        
//        JSQMessage *newMessage = nil;
//        id<JSQMessageMediaData> newMediaData = nil;
//        id newMediaAttachmentCopy = nil;
//        
//        if ([copyMessage isKindOfClass:[JSQMediaMessage class]]) {
//            /**
//             *  Last message was a media message
//             */
//            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
//            
//            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
//                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
//                
//                /**
//                 *  Set image to nil to simulate "downloading" the image
//                 *  and show the placeholder view
//                 */
//                photoItemCopy.image = nil;
//                
//                newMediaData = photoItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
//                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [locationItemCopy.location copy];
//                
//                /**
//                 *  Set location to nil to simulate "downloading" the location data
//                 */
//                locationItemCopy.location = nil;
//                
//                newMediaData = locationItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
//                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
//                
//                /**
//                 *  Reset video item to simulate "downloading" the video
//                 */
//                videoItemCopy.fileURL = nil;
//                videoItemCopy.isReadyToPlay = NO;
//                
//                newMediaData = videoItemCopy;
//            }
//            else {
//                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//            }
//            
//            newMessage = [JSQMediaMessage messageWithSenderId:randomUserId
//                                                  displayName:self.demoData.users[randomUserId]
//                                                        media:newMediaData];
//        }
//        else {
//            /**
//             *  Last message was a text message
//             */
//            newMessage = [JSQTextMessage messageWithSenderId:randomUserId
//                                                 displayName:self.demoData.users[randomUserId]
//                                                        text:copyMessage.text];
//        }
//        
//        /**
//         *  Upon receiving a message, you should:
//         *
//         *  1. Play sound (optional)
//         *  2. Add new id<JSQMessageData> object to your data source
//         *  3. Call `finishReceivingMessage`
//         */
//        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
//        [self.demoData.messages addObject:newMessage];
//        [self finishReceivingMessage];
//        
//        
//        if ([newMessage isKindOfClass:[JSQMediaMessage class]]) {
//            /**
//             *  Simulate "downloading" media
//             */
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                /**
//                 *  Media is "finished downloading", re-display visible cells
//                 *
//                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
//                 *
//                 *  Reload the specific item, or simply call `reloadData`
//                 */
//                
//                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
//                    [self.collectionView reloadData];
//                }
//                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
//                        [self.collectionView reloadData];
//                    }];
//                }
//                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
//                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
//                    [self.collectionView reloadData];
//                }
//                else {
//                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//                }
//                
//            });
//        }
//        
//    });
}


#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    NSDictionary* newMessageDictionary = [[NSDictionary alloc]initWithObjects:@[[NSNumber numberWithInt:0], text] forKeys:@[@"type", @"content"]];
    NSString* jsonData = [self returnJsonEncryption:newMessageDictionary];
    
    AVMessage* newMessage = [AVMessage messageForPeerWithSession:messageSession
                                                        toPeerId:[NSString stringWithFormat:@"%@", self.targetUser.userId]
                                                         payload:jsonData];
    
    [messageSession sendMessage:newMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    FAKIonIcons *photoIcon = [FAKIonIcons ios7PhotosOutlineIconWithSize:30];
    FAKIonIcons *cameraIcon = [FAKIonIcons ios7CameraOutlineIconWithSize:30];
    FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:30];
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
    
    actionSheet.blurRadius = 1.0f;
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
    actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                          NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#0BD318" alpha:1] };
    
    actionSheet.disabledButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#007AFF" alpha:1] };
    
    actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                     NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FF9500" alpha:1] };

    actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                NSForegroundColorAttributeName : [UIColor redColor] };
    
    [actionSheet addButtonWithTitle:@"Photo" image:[photoIcon imageWithSize:CGSizeMake(30, 30)]
                               type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *as)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self showDetailViewController:picker sender:nil];
    }];

    [actionSheet addButtonWithTitle:@"Camera" image:[cameraIcon imageWithSize:CGSizeMake(30, 30)]
                               type:AHKActionSheetButtonTypeDestructive handler:^(AHKActionSheet *as)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showDetailViewController:picker sender:nil];
    }];
    
    [actionSheet addButtonWithTitle:@"Location" image:[locationIcon imageWithSize:CGSizeMake(30, 30)]
                               type:AHKActionSheetButtonTypeDisabled handler:^(AHKActionSheet *as)
    {
        __weak UICollectionView *weakView = self.collectionView;
        
        [self.messageListData addLocationMediaMessageCompletion:^{
            [weakView reloadData];
        }];
        
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self finishSendingMessage];
    }];
    
    [actionSheet show];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* rawImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(rawImage==nil)
        rawImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(rawImage==nil)
        rawImage = [info objectForKey:UIImagePickerControllerCropRect];
    
    UIImageWriteToSavedPhotosAlbum(rawImage, nil, nil, nil);

    UIImage* scaledImage = [self imageWithImage:rawImage scaledToWidth:640];
    tmpImage = scaledImage;
    NSError* error = nil;
    
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    [imageFile save:&error];
    
    NSLog(@"error save : %@", error);
    
    NSString* fileObjectID = imageFile.objectId;
    NSDictionary* newMessageDictionary = [[NSDictionary alloc]initWithObjects:@[[NSNumber numberWithInt:1], fileObjectID] forKeys:@[@"type", @"content"]];
    NSString* jsonData = [self returnJsonEncryption:newMessageDictionary];
    
    AVMessage* newMessage = [AVMessage messageForPeerWithSession:messageSession
                                                        toPeerId:[NSString stringWithFormat:@"%@", self.targetUser.userId]
                                                         payload:jsonData];
    
    [messageSession sendMessage:newMessage];
    
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageListData.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messageListData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.messageListData.outgoingBubbleImageData;
    }
    
    return self.messageListData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
//    JSQMessage *message = [self.messageListData.messages objectAtIndex:indexPath.item];
    

    
//    return [self.messageListData.avatars objectForKey:message.senderId];
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messageListData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageListData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageListData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messageListData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messageListData.messages objectAtIndex:indexPath.item];
    
    if ([msg isKindOfClass:[JSQTextMessage class]]) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messageListData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageListData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


#pragma mark - AVSessionDelegate

- (void)onSessionOpen:(AVSession *)session {
    NSLog(@"on open");
}

- (void)onSessionPaused:(AVSession *)session {
    NSLog(@"on pause");
}

- (void)onSessionResumed:(AVSession *)seesion {
    NSLog(@"on resume");
}

- (void)onSessionMessage:(AVSession *)session message:(NSString *)message peerId:(NSString *)peerId {
    NSLog(@"on message: %@", message);
    
    NSDictionary* messageData = [self returnJsonDncryption:message];
    NSString* messageContent = [messageData objectForKey:@"content"];
    NSNumber* messageType = [messageData objectForKey:@"type"];

    if ([messageType isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        JSQTextMessage* newMessage = [JSQTextMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.messageListData.targetUserId]
                                                             displayName:self.messageListData.targetUserName
                                                                    text:messageContent];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self.messageListData.messages addObject:newMessage];
        [self storeToLocal:messageData withTargetUser:self.targetUser withMessageList:self.messageList];
        [self finishReceivingMessage];

    }else if ([messageType isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        [AVFile getFileWithObjectId:messageContent withBlock:^(AVFile* file, NSError* error){
            NSLog(@"error : %@", error);
            if (file == nil) {
                NSLog(@"file is nil");
            }else{
                NSLog(@"file's url is %@", [file url]);
            }
            
            NSData* rawData = [file getData];
            if (rawData == nil) {
                NSLog(@"rawData is nil");
            }
            
            UIImage* rawImage = [UIImage imageWithData:rawData scale:1.0];
                                 
            if (rawImage == nil) {
                NSLog(@"image is nil");
            }
            
            JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:rawImage];
            JSQMediaMessage *photoMessage = [JSQMediaMessage messageWithSenderId:[NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]]
                                                                     displayName:[currentUser objectForKey:@"name"]
                                                                           media:photoItem];
            [self.messageListData.messages addObject:photoMessage];
            [self finishReceivingMessage];
        
        }];
    }
    

    
}

- (void)onSessionMessageSent:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds{
    NSLog(@"on session message sent: %@", message);
    AVUser* currentUser = [AVUser currentUser];
    NSDictionary* messageData = [self returnJsonDncryption:message];
    NSString* messageContent = [messageData objectForKey:@"content"];
    NSNumber* messageType = [messageData objectForKey:@"type"];
    
    if ([messageType isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        JSQTextMessage* newMessage = [JSQTextMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.messageListData.userId]
                                                             displayName:self.messageListData.userName
                                                                    text:messageContent];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self.messageListData.messages addObject:newMessage];
        [self storeForSelfToLocal:messageData withMessageList:self.messageList];
        [self finishSendingMessage];
        
    }else if ([messageType isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        AVUser* currentUser = [AVUser currentUser];
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:tmpImage];
        JSQMediaMessage *photoMessage = [JSQMediaMessage messageWithSenderId:[NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]]
                                                                 displayName:[currentUser objectForKey:@"name"]
                                                                       media:photoItem];
        [self.messageListData.messages addObject:photoMessage];
        
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self finishSendingMessage];
    
    }
    
    
    messageContent = [NSString stringWithFormat:@"%@: %@", [currentUser objectForKey:@"name"], messageContent];
    if (messageContent.length > 30) {
        messageContent = [messageContent substringToIndex:30];
        messageContent = [messageContent stringByAppendingString:@"..."];
    }
    
    NSDictionary* pushData = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, @"content",
                              [currentUser objectForKey:@"userId"], @"userId",
                              messageContent, @"alert",
                              @"Increment", @"badge",
                              nil];
    
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:@"userId" equalTo:self.targetUser.userId];
    
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:pushData];
    [push sendPushInBackground];

}

- (void)onSessionError:(AVSession *)session withException:(NSException *)exception {
    NSLog(@"%@", exception);
}

@end