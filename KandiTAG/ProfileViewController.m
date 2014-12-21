//
//  ProfileViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/17/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChatTableViewController.h"
#import "MessagingNavigationController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController {
    UIView *banner;
    UILabel *title;
    UIView *following;
    UIView *followers;
    UILabel *followingLabel;
    UILabel *followersLabel;
    UIImageView *gallery;
    UIImageView *profilePic;
    UILabel *nameLabel;
    UIButton *dismiss;
    UIButton *messageButton;
    UIButton *dismissMessagingNav;
    ChatTableViewController *chatController;
    MessagingNavigationController *messagingNavController;
    UIButton *seeAllFollowing;
    UIButton *seeAllFollowers;
    UILabel *seeFollowers;
    UILabel *seeFollowing;
}


-(instancetype)initWithUserName:(NSString *)username andFbId:(NSString *)fbid andController:(UIViewController *)parent {
    self = [super init];
    if (self) {
        self.userName = username;
        self.fbID = fbid;
        self.controller = parent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    banner.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:banner];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
    title.text = self.userName;
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont fontWithName:@"Rancho" size:30]];
    title.textColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    //[self.view addSubview:title];
    
    dismiss = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2.4, self.tableView.frame.size.height - 70, 55, 55)];
    //dismiss.backgroundColor = [UIColor blueColor];
    [dismiss setImage:[UIImage imageNamed:@"dismissProfile"] forState:UIControlStateNormal];
    [dismiss addTarget:self action:@selector(dismissProfileViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:dismiss];
    
    gallery = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    gallery.backgroundColor = [UIColor grayColor];
    [self.tableView addSubview:gallery];
    
    profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(15, gallery.frame.origin.y + 195, 60, 60)];
    profilePic.clipsToBounds = YES;
    profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
    profilePic.layer.borderWidth = 2.0f;
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150", self.fbID]];
    NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
    profilePic.image = [UIImage imageWithData:picData];
    [self.tableView addSubview:profilePic];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(profilePic.frame.origin.x + 70, gallery.frame.origin.y + 185, self.view.frame.size.width - profilePic.frame.origin.x + 80, 50)];
    nameLabel.text = self.userName;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont fontWithName:@"Rancho"size:20];
    nameLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:nameLabel];
    
    messageButton = [[UIButton alloc] initWithFrame:CGRectMake(profilePic.frame.origin.x + 70, gallery.frame.origin.y + 230, 75, 22.5)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(addMessagingNavController) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:messageButton];
    
    followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gallery.frame.origin.y + 245, self.view.frame.size.width, 50)];
    followersLabel.text = @"   Followers";
    followersLabel.textAlignment = NSTextAlignmentLeft;
    followersLabel.font = [UIFont fontWithName:@"Rancho" size:14];
    followersLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:followersLabel];
    
    followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gallery.frame.origin.y + 320, self.view.frame.size.width, 50)];
    followingLabel.text = @"   Following";
    followingLabel.textAlignment = NSTextAlignmentLeft;
    followingLabel.font = [UIFont fontWithName:@"Rancho" size:14];
    followingLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:followingLabel];
    
    seeFollowers = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, gallery.frame.origin.y + 256, 75, 30)];
    seeFollowers.text = @"  See All >";
    seeFollowers.textAlignment = NSTextAlignmentCenter;
    seeFollowers.font = [UIFont fontWithName:@"Rancho" size:14];
    seeFollowers.textColor = [UIColor colorWithRed:176.0/255.0 green:240.0/255.0 blue:255.0/255.0 alpha:1];

    [self.tableView addSubview:seeFollowers];
    
    seeAllFollowers = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, gallery.frame.origin.y + 252, 75, 30)];
    //seeAllFollowers.backgroundColor = [UIColor whiteColor];
    [seeAllFollowers addTarget:self action:@selector(seeAllFollowers) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:seeAllFollowers];
    
    seeFollowing = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, gallery.frame.origin.y + 331, 75, 30)];
    seeFollowing.text = @"  See All >";
    seeFollowing.textAlignment = NSTextAlignmentCenter;
    seeFollowing.font = [UIFont fontWithName:@"Rancho" size:14];
    seeFollowing.textColor = [UIColor colorWithRed:176.0/255.0 green:240.0/255.0 blue:255.0/255.0 alpha:1];

    [self.tableView addSubview:seeFollowing];
    
    seeAllFollowing = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, gallery.frame.origin.y + 330, 75, 30)];
    //seeAllFollowing.backgroundColor = [UIColor whiteColor];
    [seeAllFollowing addTarget:self action:@selector(seeAllFollowing) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:seeAllFollowing];
    
    followers = [[UIView alloc] initWithFrame:CGRectMake(0, gallery.frame.origin.y + 282, self.view.frame.size.width, 50)];
    followers.backgroundColor = [UIColor grayColor];
    [self.tableView addSubview:followers];
    
    following = [[UIView alloc] initWithFrame:CGRectMake(0, gallery.frame.origin.y + 359, self.view.frame.size.width, 50)];
    following.backgroundColor = [UIColor grayColor];
    [self.tableView addSubview:following];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    if (y > 0) {
        gallery.frame = CGRectMake(0, scrollView.contentOffset.y, gallery.frame.size.width+y, gallery.frame.size.height+y);
        gallery.center = CGPointMake(self.tableView.center.x, gallery.center.y);
    }
    
}

-(void)addMessagingNavController {
    chatController = [[ChatTableViewController alloc] initWithFacebookId:self.fbID andUserName:self.userName];
    messagingNavController = [[MessagingNavigationController alloc] init];
    [self presentViewController:messagingNavController animated:YES completion:nil];
    [messagingNavController pushViewController:chatController animated:NO];
    dismissMessagingNav = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 25, 25)];
    [dismissMessagingNav addTarget:self action:@selector(dismissMessagingNavController) forControlEvents:UIControlEventTouchUpInside];
    [dismissMessagingNav setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [messagingNavController.view addSubview:dismissMessagingNav];
}

-(void)dismissMessagingNavController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)seeAllFollowing {
    NSLog(@"seeAllFollowing");
}

-(void)seeAllFollowers {
    NSLog(@"seeAllFollowers");
}

-(void)dismissProfileViewController {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    //[self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
