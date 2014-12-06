//
//  SettingsViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 9/14/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <FBLoginViewDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end