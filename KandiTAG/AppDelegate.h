//
//  AppDelegate.h
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "FBLoginViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *databasePath;

@property (strong, nonatomic) FBLoginViewController *fbLoginViewController;

@property (strong, nonatomic) UIPageViewController *pageViewController;


@end
