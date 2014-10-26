//
//  SettingsViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 9/14/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "SettingsViewController.h"
#import "FBLoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged in as";
    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.id;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    
    [self.profilePicture layer].cornerRadius = 5.0f;
    [self.profilePicture layer].masksToBounds = YES;
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"Please Login to Continue";
    
    NSLog(@"user logged out");
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self toggleHiddenState:YES];
    
    if(FBSessionStateClosed) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FBLoginViewController *fbvc = [storyboard instantiateViewControllerWithIdentifier:@"FBLoginViewController"];
        [fbvc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:fbvc animated:NO completion:nil];
        self.view.backgroundColor = [UIColor blackColor];
    }
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

@end