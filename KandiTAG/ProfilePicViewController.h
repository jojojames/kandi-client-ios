//
//  ProfilePicViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/5/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfilePicViewController : UIViewController <FBGraphUser, NSURLConnectionDataDelegate>

-(instancetype)initWithFacebookId:(NSString*)facebookidforpic;
-(void)setImageUsingFacebookId:(NSString*)facebookidforpic;
@property (strong, nonatomic) NSString* facebookidforpic;
@property (nonatomic) BOOL hasImage;
@property (strong, nonatomic) UIImageView* profileIcon;

@property (strong, nonatomic) UITableView* tableView;

@end
