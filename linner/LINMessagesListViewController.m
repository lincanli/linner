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
    
    self.messageListData = [[LINMessageListModelData alloc]init:self.targetUser withTargetList:self.messageList];

    self.targetUser = self.targetRelation.userObject;
    self.senderId = [NSString stringWithFormat:@"%@", self.messageListData.userId];
    self.senderDisplayName = self.messageListData.userName;

    messageSession = [[AVSession alloc] init];
    messageSession.sessionDelegate = self;

    currentUser = [AVUser currentUser];
    NSString* currentUserIdInString = [NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]];
    NSString* targetUserIdInString = [NSString stringWithFormat:@"%@", self.targetUser.userId];
    [messageSession openWithPeerId:currentUserIdInString watchedPeerIds:@[targetUserIdInString]];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.title = self.targetUser.userRealName;
    self.showLoadEarlierMessagesHeader = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(profileForPointToPoint:)];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}



#pragma mark - Actions

- (void)profileForPointToPoint:(UIBarButtonItem *)sender
{
    LINProfileTableViewControllerPointToPoint* profileForPointToPoint = [[LINProfileTableViewControllerPointToPoint alloc]init];
    profileForPointToPoint.targetUserRelation = self.targetRelation;
    profileForPointToPoint.messageList = self.messageList;
    [self showViewController:profileForPointToPoint sender:nil];
}


#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    NSLog(@"%@     %@     %@     %@ ", senderId, senderDisplayName, date, text);
    
    JSQMessage *newMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%@", self.messageListData.userId] senderDisplayName:self.messageListData.userName date:date text:text];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self.messageListData.messages addObject:newMessage];
    [self finishSendingMessage];
    
    NSMutableDictionary* newMessageDictionary = [[NSMutableDictionary alloc]initWithObjects:@[[NSNumber numberWithInt:0], text]
                                                                                    forKeys:@[@"type", @"content"]];
    NSString* jsonData = [self returnJsonEncryption:newMessageDictionary];
    
    [self storeForSelfToLocal:newMessageDictionary withMessageList:self.messageList withMessageType:[NSNumber numberWithInt:0]];
    AVMessage* sentNewMessage = [AVMessage messageForPeerWithSession:messageSession
                                                            toPeerId:[NSString stringWithFormat:@"%@", self.targetUser.userId]
                                                             payload:jsonData];
    [messageSession sendMessage:sentNewMessage];

}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    FAKIonIcons *photoIcon = [FAKIonIcons ios7PhotosOutlineIconWithSize:30];
    FAKIonIcons *cameraIcon = [FAKIonIcons ios7CameraOutlineIconWithSize:30];
    FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:30];
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
    
    actionSheet.blurRadius = 2.0f;
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
         picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         [self showDetailViewController:picker sender:nil];
     }];
    
    [actionSheet addButtonWithTitle:@"Camera" image:[cameraIcon imageWithSize:CGSizeMake(30, 30)]
                               type:AHKActionSheetButtonTypeDestructive handler:^(AHKActionSheet *as)
     {
         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
         picker.delegate = self;
         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    UIImage* scaledImage = [self imageWithImage:rawImage scaledToWidth:160];
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:scaledImage];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]]
                                                   displayName:[currentUser objectForKey:@"name"]
                                                         media:photoItem];
    
    [self.messageListData.messages addObject:photoMessage];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessage];
    
    
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(!succeeded){
            return;
        }
        
        NSString* fileUrl = [imageFile url];
        [imageFile clearCachedFile];
        
        NSMutableDictionary * newMessageDictionary = [[NSMutableDictionary alloc]initWithObjects:@[[NSNumber numberWithInt:1], fileUrl]
                                                                                         forKeys:@[@"type", @"content"]];
        NSString* jsonData = [self returnJsonEncryption:newMessageDictionary];
        
        [newMessageDictionary setValue:scaledImage forKey:@"messageMedia"];
        [self storeForSelfToLocal:newMessageDictionary withMessageList:self.messageList withMessageType:[NSNumber numberWithInt:1]];
        
        AVMessage* newMessage = [AVMessage messageForPeerWithSession:messageSession
                                                            toPeerId:[NSString stringWithFormat:@"%@", self.targetUser.userId]
                                                             payload:jsonData];
        [messageSession sendMessage:newMessage];
        
    }];
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
    
    if (!msg.isMediaMessage) {
        
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
    
    NSMutableDictionary* messageData = [self returnJsonDncryption:message];
    NSString* messageContent = [messageData objectForKey:@"content"];
    NSNumber* messageType = [messageData objectForKey:@"type"];
    
    if ([messageType isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        JSQMessage* newMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.messageListData.targetUserId]
                                                     displayName:self.messageListData.targetUserName
                                                            text:messageContent];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self.messageListData.messages addObject:newMessage];
        [self storeToLocal:messageData withTargetUser:self.targetUser withMessageList:self.messageList];
        [self finishReceivingMessage];
        
    }else if ([messageType isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        UIImage* nilImage = [[UIImage alloc]init];
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:nilImage];
        JSQMessage *photoMessage = [JSQMessage messageWithSenderId:[NSString stringWithFormat:@"%@", self.messageListData.targetUserId]
                                                       displayName:self.messageListData.targetUserName
                                                             media:photoItem];
        [self.messageListData.messages addObject:photoMessage];
        [self finishReceivingMessage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVFile* imageFile = [AVFile fileWithURL:messageContent];
            
            NSData* rawData = [imageFile getData];
            UIImage* rawImage = [UIImage imageWithData:rawData];
            ((JSQPhotoMediaItem *)photoItem).image = rawImage;
            [imageFile clearCachedFile];
            [imageFile deleteInBackground];
            
            [messageData setValue:rawImage forKey:@"messageMedia"];
            [self storeImageToLocal:messageData withTargetUser:self.targetUser withMessageList:self.messageList];
            [self.collectionView reloadData];
        });
    }
}

- (void)onSessionMessageSent:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds{
    NSLog(@"on session message sent: %@", message);
    AVUser* currentUser = [AVUser currentUser];
    NSMutableDictionary* messageData = [self returnJsonDncryption:message];
    NSString* messageContent = [messageData objectForKey:@"content"];
    
    messageContent = [NSString stringWithFormat:@"%@: %@", [currentUser objectForKey:@"name"], messageContent];
    if (messageContent.length > 30) {
        messageContent = [messageContent substringToIndex:30];
        messageContent = [messageContent stringByAppendingString:@"..."];
    }
    
    NSMutableDictionary* pushData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
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