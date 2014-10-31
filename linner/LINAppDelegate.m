//
//  LINAppDelegate.m
//  linner
//
//  Created by Lincan Li on 7/26/14.
//  Copyright (c) 2014 ___Lincan Li___. All rights reserved.
//

#import "LINAppDelegate.h"
#import <Sinch/Sinch.h>
#import "Stripe.h"

#import "LINMainViewController.h"
#import "LINCallingViewController.h"

#import "LINAppDelegate+DataModel.h"

@implementation LINAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

NSString * const StripePublishableKey = @"pk_test_0hh6eMglKBNlFUBhnVOdsSSJ";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [AVOSCloud useAVCloudUS];

    [AVOSCloud setApplicationId:@"dnrltp67optv4amgcg73v3u7i4jp09r5x5qgn5dmkndkwvg6"
                      clientKey:@"l3dv1nhuo3tklitahbnwzfu3gzdva52mc515eg5ctpofu6e0"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Stripe setDefaultPublishableKey:StripePublishableKey];

    
    NSLog(@"app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
 
//    [self saveRemoteNotificationToLocal:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    
#pragma mark - basic app setting and framework register
    UIUserNotificationSettings *settings =[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeAlert |UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    

    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        NSLog(@"UserDidFound");
        [self initSinchClientWithUserId:[NSString stringWithFormat:@"%@", [currentUser objectForKey:@"userId"]]];
        UITabBarController *tabBarController = [[LINMainViewController alloc] init];
        self.window.rootViewController = tabBarController;
        
    } else {
        NSLog(@"UserDidNotFound");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndLogout" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

#pragma mark - life cycle
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - notification handle

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    //handle the actions
    NSLog(@"received notification: %@", userInfo);
    [self saveRemoteNotificationToLocal:userInfo];
    handler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Remote Notification did registere
    AVUser * currentUser = [AVUser currentUser];
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[currentUser objectForKey:@"userId"] forKey:@"userId"];
    [currentInstallation saveInBackground];
    
    NSLog(@"Phase Init AppDel - didRegisterForRemoteNotification");
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Phase Init AppDel - didFailRegisterForRemoteNotification: %@", error);
}


#pragma mark - Sinch Related

- (void)initSinchClientWithUserId:(NSString *)userId {
    if (!_client) {
        
        NSLog(@"sinch : %@", userId);
        _client = [Sinch clientWithApplicationKey:@"cd7dab9d-d1ed-438b-b34c-b8b61b533273"
                                applicationSecret:@"Bt93cbrzlUiG8795LJTjCA=="
                                  environmentHost:@"sandbox.sinch.com"
                                           userId:userId];
        
        self.userId = userId;
        _client.delegate = self;
        _client.callClient.delegate = self;
        [_client setSupportCalling:YES];
        [_client setSupportMessaging: NO];
        [_client setSupportActiveConnectionInBackground:YES];
        [_client setSupportPushNotifications:NO];
        [_client start];
        [_client startListeningOnActiveConnection];
    }
}

- (id<SINClient>)client {
    return _client;
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client
{
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidStop:(id<SINClient>)client
{
    NSLog(@"Sinch client stopped");
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)client:(id<SINClient>)client logMessage:(NSString *)message area:(NSString *)area severity:(SINLogSeverity)severity timestamp:(NSDate *)timestamp
{
    if (severity == SINLogSeverityCritical) {
        NSLog(@"%@", message);
    }
}

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    // Start playing ringing tone
    NSLog(@"call received!");
    UIStoryboard *callingStoryBoard = [UIStoryboard storyboardWithName:@"Calling" bundle:nil];
    LINCallingViewController *callingVC = [callingStoryBoard instantiateViewControllerWithIdentifier:@"LINCallingViewController"];

    callingVC.call = call;
    call.delegate = callingVC;
    [self.window.rootViewController presentViewController:callingVC animated:YES completion:nil];
}

#pragma mark - core data

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Linner.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
