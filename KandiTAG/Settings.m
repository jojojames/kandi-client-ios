//
//  Settings.m
//  KandiTAG
//
//  Created by Jim Chen on 12/12/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "Settings.h"
#import "FbLogin.h"

@interface Settings () {
    FbLogin *fbLogin;
    UIButton *backToScanner;
}

@end

@implementation Settings

@synthesize loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self toggleHiddenState:YES];
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton = [[FBLoginView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height / 1.2, self.view.frame.size.width - 100, 30)];
    [self.view addSubview:loginButton];
    self.loginButton.delegate = self;
    UINavigationBar *settingBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *settingsTitle = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    [settingBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Rancho" size:30], NSFontAttributeName , [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    [settingBar pushNavigationItem:settingsTitle animated:NO];
    [self.view addSubview:settingBar];
    
    backToScanner = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [backToScanner setImage:[UIImage imageNamed:@"qrScannerButton"] forState:UIControlStateNormal];
    [backToScanner addTarget:self action:@selector(removeSettingsFromView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToScanner];
    
    self.profilePicture = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3.15, self.view.frame.size.height / 3.75, 110, 110)];
    [self.view addSubview:self.profilePicture];
}

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
