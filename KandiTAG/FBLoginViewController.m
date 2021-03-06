//
//  fbLoginViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 9/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "FBLoginViewController.h"
#import "AppDelegate.h"
#import "PageViewController.h"

@implementation FBLoginViewController {
    UIImageView *background;
    PageViewController *pageViewController;
}
@synthesize responseData;
@synthesize requestedLogin;
@synthesize pageViewController;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


- (void)viewDidLoad {
    [super viewDidLoad];
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
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
    pageViewController = [[PageViewController alloc] init];
}

-(void)toggleHiddenState:(BOOL)shouldHide {
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
    self.loginButton.hidden = shouldHide;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //self.loginButton.hidden = YES;
    
    self.lblLoginStatus.text = @"Welcome!";
    [self toggleHiddenState:YES];
    if (FBSession.activeSession.isOpen) {
        [self presentViewController:pageViewController animated:NO completion:nil];
        //[self performSegueWithIdentifier:@"toApp" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        [self presentViewController:pageViewController animated:NO completion:nil];
        //[self performSegueWithIdentifier:@"toApp" sender:self];
    }
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)fbuser {
    //NSLog(@"-loginViewFetchedUserInfo:\n %@", fbuser);
    self.profilePicture.profileID = fbuser.id;
    self.lblUsername.text = fbuser.name;
    self.lblEmail.text = [fbuser objectForKey:@"email"];
    //NSLog(@"user data fetched");

    //store fbid and name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.lblUsername.text forKey:@"NAME"];
    [defaults setObject:self.profilePicture.profileID forKey:@"FBID"];
    
    NSString *userName = [defaults stringForKey:@"NAME"];
    NSString *FBid = [defaults stringForKey:@"FBID"];
    
    NSLog(@"current user: %@ - %@", userName, FBid);
    if (!requestedLogin) {
        responseData = [[NSMutableData alloc] init];
        [[AppDelegate KandiAppDelegate].network requestLogin:self];
        requestedLogin = YES;
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.lblLoginStatus.text = @"Please Login to Continue";
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

@end