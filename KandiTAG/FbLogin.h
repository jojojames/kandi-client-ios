//
//  FbLogin.h
//  KandiTAG
//
//  Created by Jim Chen on 12/12/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PageViewController.h"

@interface FbLogin : UIViewController <FBLoginViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) FBLoginView *loginButton;
@property (strong, nonatomic) NSString *lblUsername;
@property (strong, nonatomic) NSString *facebookid;
@property (weak, nonatomic) FBProfilePictureView *profilePicture;
@property (strong, nonatomic) PageViewController *pageViewController;

-(instancetype)init;

-(void)toggleHiddenState:(BOOL)shouldHide;
@property (nonatomic) BOOL requestedLogin;
@property (strong, nonatomic) NSMutableData* responseData;


@end
