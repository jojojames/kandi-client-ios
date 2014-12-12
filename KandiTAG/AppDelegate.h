//
//  AppDelegate.h
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FbLogin.h"
#import "NetworkUtil.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *databasePath;

@property (strong, nonatomic) FbLogin *fbLogin;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSUserDefaults* defaults;

@property (strong, nonatomic) NetworkUtil* network;
@property (strong, nonatomic) NSString* mainUserId;
@property (strong, nonatomic) NSString* facebookId;
@property (strong, nonatomic) NSString* currentQrCode;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* deviceToken;
@property (strong, nonatomic) NSString* currentQrPicId;

@property (nonatomic) BOOL pageScrollEnabled;

+ (AppDelegate*)KandiAppDelegate;
-(NSString*)UserId;
@end
