//
//  SettingsViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 9/14/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "SettingsViewController.h"
#import "FBLoginViewController.h"
#import "PageViewController.h"

@interface SettingsViewController () {
    UIButton *backToScanner;
    UIButton *addKandi;
    UITextField *add;
    UIView *addKandiView;
    UIButton *removeAdd;
    UIButton *saveKandi;
    UITextField *bio;
    UILabel *DoubleTapLabel;
    UIButton *DoubleTapSwitch;
}

@end

@implementation SettingsViewController

#define MAX_LENGTH 6

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
    UINavigationBar *settingBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *settingsTitle = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    [settingBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Rancho" size:25], NSFontAttributeName , [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    [settingBar pushNavigationItem:settingsTitle animated:NO];
    [self.view addSubview:settingBar];
    
    DoubleTapLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, 35)];
    DoubleTapLabel.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:0.5];
    DoubleTapLabel.text = @" Double Tap To Turn On Flashlight";
    DoubleTapLabel.textAlignment = NSTextAlignmentLeft;
    DoubleTapLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:20];
    //[self.view addSubview:DoubleTapLabel];
    
    backToScanner = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [backToScanner setImage:[UIImage imageNamed:@"qrScannerButton"] forState:UIControlStateNormal];
    [backToScanner addTarget:self action:@selector(removeSettingsFromView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToScanner];
    
    addKandi = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 30, 30)];
    [addKandi setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
    [addKandi addTarget:self action:@selector(addKandiTAG) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:addKandi];
    //add this after release
}


-(void)removeSettingsFromView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addKandiTAG {
    NSLog(@"need to add KandiTAG");
    removeAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [removeAdd addTarget:self action:@selector(removeAddKandiTAG) forControlEvents:UIControlEventTouchUpInside];
    addKandiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    addKandiView.backgroundColor = [UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:120.0f/255.0 alpha:0.9f];
    //addKandiView.layer.cornerRadius = 10.0f;
    add = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 5.25, self.view.frame.size.height / 3, 200, 30)];
    add.delegate = self;
    add.textAlignment =  NSTextAlignmentCenter;
    add.backgroundColor = [UIColor whiteColor];
    add.layer.cornerRadius = 10.0f;
    saveKandi = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.9, self.view.frame.size.height / 2.4, 100, 35)];
    [saveKandi setTitle:@"REDEEM" forState:UIControlStateNormal];
    saveKandi.layer.borderWidth = 3.0f;
    saveKandi.layer.borderColor = [UIColor whiteColor].CGColor;
    saveKandi.layer.cornerRadius = 10.0f;
    //[saveKandi setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
    [saveKandi addTarget:self action:@selector(saveKandi) forControlEvents:UIControlEventTouchUpInside];
    UIButton *remove = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [remove addTarget:self action:@selector(removeAddKandiTAG) forControlEvents:UIControlEventTouchUpInside];
    [addKandiView addSubview:remove];
    [addKandiView addSubview:saveKandi];
    [addKandiView addSubview:add];
    [self.view addSubview:removeAdd];
    [self.view addSubview:addKandiView];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    add = textField;
    NSUInteger newLength = [add.text length] + [string length] - range.length;
    return (newLength > 6) ? NO : YES;
}

-(void)removeAddKandiTAG {
    [addKandiView removeFromSuperview];
    [removeAdd removeFromSuperview];
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

-(void)saveKandi {
    NSLog(@"need to set up network connection");
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged in as";

    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    //NSLog(@"%@", user);
    self.profilePicture.profileID = user.id;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    //[self.profilePicture layer].cornerRadius = 5.0f;
    self.profilePicture.layer.borderWidth = 3.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profilePicture layer].masksToBounds = YES;
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"Please Login to Continue";
    
    //NSLog(@"user logged out");
    
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
    //NSLog(@"%@", [error localizedDescription]);
}

@end