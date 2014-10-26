//
//  KandiProfileViewController.h
//  KandiTAG
//
//  Created by James Nguyen on 10/25/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KandiProfileViewController : UIViewController
@property (strong, nonatomic) UIImageView* profileIcon;
@property (strong, nonatomic) UIButton* facebookSend;
@property (strong, nonatomic) UIButton* facebookAdd;
-(instancetype)initWithFacebookId:(NSString*)_facebookId;
@property (strong, nonatomic) NSString* facebookId;
@property (strong, nonatomic) UITapGestureRecognizer* tap;
@end
