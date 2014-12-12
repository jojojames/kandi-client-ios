//
//  AppDelegate.m
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "KandiTableViewController.h"
#import "VersionCheck.h"

@implementation AppDelegate
@synthesize network;
@synthesize mainUserId;
@synthesize defaults;
@synthesize facebookId;
@synthesize userName;
@synthesize currentQrCode;
@synthesize deviceToken;
@synthesize currentQrPicId;
@synthesize pageScrollEnabled;

+(AppDelegate*)KandiAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(NSUserDefaults*)defaults {
    if (!defaults)
        defaults = [NSUserDefaults standardUserDefaults];
    return defaults;
}

-(NSString*)facebookId {
    if (!facebookId)
        facebookId = [self.defaults stringForKey:@"FBID"];
    return facebookId;
}

-(NSString*)userName {
    if (!userName) {
        userName = [self.defaults stringForKey:@"NAME"];
    }
    return userName;
}

-(NSString*)mainUserId {
    if (!mainUserId)
        mainUserId = [self.defaults stringForKey:@"USERID"];
    return mainUserId;
}

-(NSString*)deviceToken {
    if (!deviceToken)
        deviceToken = [self.defaults stringForKey:@"DEVICETOKEN"];
    return deviceToken;
}

-(NSString*)currentQrPicId {
    if (!currentQrPicId)
        currentQrPicId = [self.defaults stringForKey:@"CURRENTQRPICID"];
    return currentQrPicId;
}

-(BOOL)pageScrollEnabled {
    if (!pageScrollEnabled)
        pageScrollEnabled = [self.defaults boolForKey:@"PAGESCROLLENABLED"];
    return pageScrollEnabled;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.fbLogin = [[FbLogin alloc] init];
    self.window.rootViewController = self.fbLogin;
    [self.window makeKeyAndVisible];
    
    pageScrollEnabled = YES;
    
    [FBLoginView class];
    [FBProfilePictureView class];
    network = [[NetworkUtil alloc] init];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)device_Token {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", device_Token);
    NSString* token = [[device_Token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [defaults setObject:token forKey:@"DEVICETOKEN"];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Push received: %@", userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 2;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}
							
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
