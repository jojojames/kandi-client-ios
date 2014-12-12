//
//  FbLogin.m
//  KandiTAG
//
//  Created by Jim Chen on 12/12/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "FbLogin.h"
#import "AppDelegate.h"

@interface FbLogin ()

@end

@implementation FbLogin {
    UIImageView *background;
}

@synthesize loginButton;
@synthesize requestedLogin;
@synthesize pageViewController;
@synthesize responseData;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


-(instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"FbLogin Initialied");
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self toggleHiddenState:NO];
    loginButton = [[FBLoginView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height / 1.35, self.view.frame.size.width - 100, 30)];
    [self.view addSubview:loginButton];
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if (IS_IPHONE_5) {
        background.image = [UIImage imageNamed:@"Official640x1136"];
        [self.view addSubview:background];
        [self.view addSubview:self.loginButton];
    } else {
        background.image = [UIImage imageNamed:@"Official640x960"];
        [self.view addSubview:background];
        [self.view addSubview:self.loginButton];
    }
    pageViewController = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
}

-(void)toggleHiddenState:(BOOL)shouldHide {
    self.profilePicture.hidden = shouldHide;
    self.loginButton.hidden = shouldHide;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //[self toggleHiddenState:YES];
    self.loginButton.hidden = YES;
    if (FBSession.activeSession.isOpen) {
        self.loginButton.hidden = YES;
        [self presentViewController:pageViewController animated:NO completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        self.loginButton.hidden = YES;
        [self presentViewController:pageViewController animated:NO completion:nil];
    }
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)fbuser {
    self.profilePicture.profileID = fbuser.id;
    self.lblUsername = fbuser.name;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.lblUsername forKey:@"NAME"];
    [defaults setObject:self.profilePicture.profileID forKey:@"FBID"];
    
    if (!requestedLogin) {
        responseData = [[NSMutableData alloc] init];
        [[AppDelegate KandiAppDelegate].network requestLogin:self];
        requestedLogin = YES;
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self toggleHiddenState:YES];
    self.loginButton.hidden = NO;
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    //NSLog(@"error in FBLoginViewController: %@", [error localizedDescription]);
}

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //if we get any connection error manage it here
    //for example use alert view to say no internet connection
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    if ([json objectForKey:@"success"]) {
        NSNumber* success = [json objectForKey:@"success"];
        if ([success boolValue]) {
            NSString* userId = (NSString*)[json objectForKey:@"user_id"];
            [AppDelegate KandiAppDelegate].mainUserId = userId;
            NSLog(@"FBLoginViewController: connectionDidFinishLoading: user_id: %@", userId);
        } else {
            // todo; show an alert that the login was not successful for whatever reason
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
