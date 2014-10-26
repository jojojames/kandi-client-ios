//
//  KandiProfileViewController.m
//  KandiTAG
//
//  Created by James Nguyen on 10/25/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation KandiProfileViewController
@synthesize profileIcon;
@synthesize facebookAdd;
@synthesize facebookSend;
@synthesize facebookId;
@synthesize tap;

-(instancetype)initWithFacebookId:(NSString*)_facebookId {
    self = [super init];
    if (self) {
        self.profileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        
        [self.profileIcon layer].cornerRadius = 5.0f;
        [self.profileIcon layer].masksToBounds = YES;

        self.facebookSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.facebookSend.frame = CGRectMake(0, 0, 130, 40);
        [self.facebookSend setTitle:@"Send Message" forState:UIControlStateNormal];
        
        self.facebookAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.facebookAdd.frame = CGRectMake(0, 0, 130, 40);
        [self.facebookAdd setTitle:@"Add Friend" forState:UIControlStateNormal];
        
        self.facebookId = _facebookId;
        
        [self.facebookAdd layer].borderWidth = 1.0f;
        [self.facebookSend layer].borderWidth = 1.0f;
        [self.facebookSend layer].borderColor = self.facebookSend.titleLabel.textColor.CGColor;
        [self.facebookAdd layer].borderColor = self.facebookAdd.titleLabel.textColor.CGColor;
        
        [self.facebookSend layer].cornerRadius = 5.0f;
        [self.facebookAdd layer].cornerRadius = 5.0f;
        
        [self.view addSubview:profileIcon];
        [self.view addSubview:facebookSend];
        [self.view addSubview:facebookAdd];
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.facebookAdd.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.facebookSend.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.facebookSend addTarget:self action:@selector(facebookSendButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self.facebookAdd addTarget:self action:@selector(facebookAddButtonPressed) forControlEvents:UIControlEventTouchDown];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
        tap.enabled = YES;
        [self.profileIcon addGestureRecognizer:tap];
        self.profileIcon.userInteractionEnabled = YES;
    }
    return self;
}

-(void)facebookSendButtonPressed {
    
}

-(void)facebookAddButtonPressed {
    
}

-(void)imageTapped {
    //NSString* urlString = [NSString stringWithFormat:@"fb://profile/%@", facebookId];
    //NSURL *url = [NSURL URLWithString:urlString];
    //[[UIApplication sharedApplication] openURL:url];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/addfriend.php?id=%@", facebookId]];
    //[[UIApplication sharedApplication] openURL:url];
   // NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: facebookId, @"id", nil];
    [FBWebDialogs presentDialogModallyWithSession:nil dialog:@"friends" parameters:params handler:nil];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", facebookId]];
    NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
    self.profileIcon.image = [UIImage imageWithData:picData];
    [self setNameForTitle];
}

-(void)setNameForTitle {
    NSError* error;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@", facebookId]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        NSDictionary* jsonResponse = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
        if ([jsonResponse objectForKey:@"name"]) {
            NSString* name = [jsonResponse objectForKey:@"name"];
            if (name)
                self.title = name;
            else
                self.title = @"Profile";
        }
    } else {
        self.title = @"Profile";
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.frame;
    self.profileIcon.frame = CGRectMake(frame.size.width / 2 - self.profileIcon.frame.size.width / 2, 100, self.profileIcon.frame.size.width, self.profileIcon.frame.size.height);
    self.facebookAdd.frame = CGRectMake(frame.size.width / 2 - self.facebookAdd.frame.size.width - 10, self.profileIcon.frame.origin.y + self.profileIcon.frame.size.height + 100, self.facebookAdd.frame.size.width, self.facebookAdd.frame.size.height);
    self.facebookSend.frame = CGRectMake(frame.size.width / 2 + 10, self.profileIcon.frame.origin.y + self.profileIcon.frame.size.height + 100, self.facebookSend.frame.size.width, self.facebookSend.frame.size.height);
    
    [self.facebookSend.titleLabel sizeToFit];
    [self.facebookAdd.titleLabel sizeToFit];
}

@end
