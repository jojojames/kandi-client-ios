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

@implementation AppDelegate
@synthesize network;
@synthesize mainUserId;
@synthesize defaults;
@synthesize facebookId;
@synthesize userName;
@synthesize currentQrCode;

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.fbLoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"FBLoginViewController"];
    self.window.rootViewController = self.fbLoginViewController;
    [self.window makeKeyAndVisible];
    
    [FBLoginView class];
    [FBProfilePictureView class];
    network = [[NetworkUtil alloc] init];
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
