//
//  ProfilePicViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/5/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfilePicViewController : UIViewController <FBGraphUser, NSURLConnectionDataDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

-(instancetype)init;
-(void)setImageUsingFacebookIdfor1:(NSString*)facebookidforpic;
-(void)setImageUsingFacebookIdfor2:(NSString*)facebookidforpic;
-(void)setImageUsingFacebookIdfor3:(NSString*)facebookidforpic;
-(void)setImageUsingFacebookIdfor4:(NSString*)facebookidforpic;
-(void)setImageUsingFacebookIdfor5:(NSString*)facebookidforpic;

@property (strong, nonatomic) NSString* facebookidforpic;
@property (nonatomic) BOOL hasImage;
@property (strong, nonatomic) UIImageView* profileIcon;
@property (strong, nonatomic) UIImageView* profileIcon1;
@property (strong, nonatomic) UIImageView* profileIcon2;
@property (strong, nonatomic) UIImageView* profileIcon3;
@property (strong, nonatomic) UIImageView* profileIcon4;
@property (strong, nonatomic) UIImageView* profileIcon5;

@property (strong, nonatomic) UITableView* tableView;

-(void)removePic;

@end
