//
//  DetailViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "DetailViewController.h"
#import "ChatTableViewController.h"
#import "MessagingNavigationController.h"
#import "AppDelegate.h"
#import "DetailPageController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    UIImageView *profileImage;
    UILabel *nameLabel;
    UILabel *placementLabel;
    NSString *actualPlacement;
    UITapGestureRecognizer *tap;
    ChatTableViewController *chatController;
    MessagingNavigationController *messagingNavController;
    DetailPageController *detailPageController;
    UIButton *dismiss;
}

@synthesize fbid;
@synthesize user_name;

-(instancetype)initWithFacebookId:(NSString *)facebookid name:(NSString *)name placement:(NSInteger)place{
    self = [super init];
    if (self) {
        self.fbid = facebookid;
        self.user_name = name;
        self.placement = place;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3.9, 10, 150, 150)];
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=160&height=160", self.fbid]];
    NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
    profileImage.image = [UIImage imageWithData:picData];
    
    profileImage.clipsToBounds = YES;
    profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImage.layer.borderWidth = 3.0f;
    profileImage.layer.cornerRadius = profileImage.frame.size.width /2;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMessage)];
    tap.numberOfTapsRequired = 1;
    [profileImage setUserInteractionEnabled:YES];
    [profileImage addGestureRecognizer:tap];

    [self.view addSubview:profileImage];
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 162, self.view.frame.size.width, 25)];
    nameLabel.text = [NSString stringWithFormat:@"%@ - %d/5", self.user_name, self.placement];
    nameLabel.font = [UIFont fontWithName:@"Rancho" size:20];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:nameLabel];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    
    
}

-(void)openMessage {
    NSLog(@"need to open message");
    chatController = [[ChatTableViewController alloc] initWithFacebookId:self.fbid andUserName:self.user_name];
    
    NSString *facebookId = [AppDelegate KandiAppDelegate].facebookId;
    
    if (![self.fbid isEqual:facebookId]) {
        
        messagingNavController = [[MessagingNavigationController alloc] init];
        
        detailPageController = [[DetailPageController alloc] init];
        
        [self.view addSubview:detailPageController.view];
        
        [detailPageController presentViewController:messagingNavController animated:YES completion:nil];
        
        [messagingNavController pushViewController:chatController animated:NO];
        
        dismiss = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 25, 25)];
        [dismiss addTarget:self action:@selector(removeMessagingController) forControlEvents:UIControlEventTouchUpInside];
        [dismiss setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [messagingNavController.view addSubview:dismiss];
        
    }
}

-(void)removeMessagingController {
    NSLog(@"removeMessagingController");
    [detailPageController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
