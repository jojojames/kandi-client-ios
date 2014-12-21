//
//  Settings.m
//  KandiTAG
//
//  Created by Jim Chen on 12/12/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "Settings.h"
#import "AppDelegate.h"

@interface Settings () {
    FbLogin *fbLogin;
    UIButton *backToScanner;
    UILabel *nameLabel;
    UIImageView *gallery;
    UIView *followers;
    UIView *following;
    UILabel *followingLabel;
    UILabel *followersLabel;
    UIButton *seeAllFollowing;
    UIButton *seeAllFollowers;
}

@end

@implementation Settings

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@synthesize loginButton;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    UINavigationBar *settingBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *settingsTitle = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    [settingBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Rancho" size:30], NSFontAttributeName , [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    [settingBar pushNavigationItem:settingsTitle animated:NO];
    //[self.view addSubview:settingBar];
    
    backToScanner = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2.35, 10, 44, 44)];
    [backToScanner setImage:[UIImage imageNamed:@"dismissProfile"] forState:UIControlStateNormal];
    [backToScanner addTarget:self action:@selector(removeSettingsFromView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToScanner];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    //[self.view addSubview:scrollView];
    
    //CGRectMake(23, 50, myview.frame.size.width, myview.frame.size.height);
    
    gallery = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    gallery.backgroundColor = [UIColor whiteColor];
    gallery.image = [UIImage imageNamed:@"messageBackground"];
    gallery.contentMode = UIViewContentModeScaleAspectFill;
    //[self.scrollView addSubview:gallery];
    //[self.scrollView sendSubviewToBack:gallery];
    [self.tableView addSubview:gallery];
    [self.tableView sendSubviewToBack:gallery];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 170)];

    
    self.profilePicture = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(15, gallery.frame.size.height + 17, 60, 60)];
    [self.tableView addSubview:self.profilePicture];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.profilePicture.frame.origin.x + 70, gallery.frame.size.height + 30, self.view.frame.size.width - self.profilePicture.frame.origin.x, 30)];
    nameLabel.text = [AppDelegate KandiAppDelegate].userName;
    nameLabel.font = [UIFont fontWithName:@"Rancho" size:25];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.tableView addSubview:nameLabel];
    
    followers = [[UIView alloc] initWithFrame:CGRectMake(0, gallery.frame.size.height + 100, self.view.frame.size.width, 50)];
    followers.backgroundColor = [UIColor yellowColor];
    [self.tableView addSubview:followers];
    
    following = [[UIView alloc] initWithFrame:CGRectMake(0, gallery.frame.size.height + 170, self.view.frame.size.width, 50)];
    following.backgroundColor = [UIColor greenColor];
    [self.tableView addSubview:following];
    
    followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gallery.frame.size.height + 65, self.view.frame.size.width, 50)];
    followersLabel.text = @"   Followers";
    followersLabel.textAlignment = NSTextAlignmentLeft;
    followersLabel.font = [UIFont fontWithName:@"Rancho" size:14];
    followersLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:followersLabel];
    
    followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gallery.frame.size.height + 135, self.view.frame.size.width, 50)];
    followingLabel.text = @"   Following";
    followingLabel.textAlignment = NSTextAlignmentLeft;
    followingLabel.font = [UIFont fontWithName:@"Rancho" size:14];
    followingLabel.textColor = [UIColor whiteColor];
    [self.tableView addSubview:followingLabel];
    
    
    [self toggleHiddenState:YES];
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    if (IS_IPHONE_5) {
    loginButton = [[FBLoginView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height / 1.3, self.view.frame.size.width - 100, 30)];
    } else {
        loginButton = [[FBLoginView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height / 1.15, self.view.frame.size.width - 100, 30)];
    }
    [self.tableView addSubview:loginButton];
    self.loginButton.delegate = self;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = -scrollView.contentOffset.y;
    if (y > 0) {
        gallery.frame = CGRectMake(0, scrollView.contentOffset.y, gallery.frame.size.width+y, gallery.frame.size.height+y);
        gallery.center = CGPointMake(self.scrollView.center.x, gallery.center.y);
    }
    
}

/*

- (void)killScroll
{
    if (!IS_IPHONE_5) {
    CGPoint offset = scrollView.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [scrollView setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [scrollView setContentOffset:offset animated:NO];
        
    }
}
 
 */

-(void)removeSettingsFromView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    self.profilePicture.hidden = shouldHide;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    //NSLog(@"%@", user);
    self.profilePicture.profileID = user.id;
    self.lblUsername = user.name;
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.layer.borderWidth = 3.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profilePicture layer].masksToBounds = YES;
    self.profilePicture.clipsToBounds = YES;
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self toggleHiddenState:YES];
    if(FBSessionStateClosed) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    //NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
