//
//  LINAppDelegate.h
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LINUserObject.h"

@interface LINAppDelegate : UIResponder <UIApplicationDelegate, SINClientDelegate, SINCallClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSData* installationID;
@property (weak, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) id<SINClient> client;
- (void)initSinchClientWithUserId:(NSString *)userId;

@property (strong, nonatomic) NSString* userId;

@end
