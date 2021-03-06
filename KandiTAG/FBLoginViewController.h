//
//  fbLoginViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 9/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PageViewController.h"

@interface FBLoginViewController : UIViewController <FBLoginViewDelegate, NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblUsername;

@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@property (strong, nonatomic) PageViewController *pageViewController;


-(void)toggleHiddenState:(BOOL)shouldHide;

@property (nonatomic) BOOL requestedLogin;
@property (strong, nonatomic) NSMutableData* responseData;

@end