//
//  QRCodeSaveDelegate.m
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//


#import "QRCodeSaveDelegate.h"
#import "VersionCheck.h"
#import "AppDelegate.h"

@implementation QRCodeSaveDelegate
@synthesize responseData;
@synthesize controller;
#pragma mark - NSURLConnection Delegate

-(instancetype)initWithController:(UIViewController*)parent {
    self = [super init];
    if (self) {
        self.responseData = [[NSMutableData alloc] init];
        self.controller = parent;
    }
    return self;
}

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
    
    if (responseData) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:kNilOptions
                              error:&error];
        
        if ([json objectForKey:@"success"]) {
            NSNumber* success = [json objectForKey:@"success"];
            if ([success boolValue]) {
                // QRCode was saved properly
                NSString* qrCodeId = (NSString*)[json objectForKey:@"qrcode_id"];
                NSString* qrCode = (NSString*)[json objectForKey:@"qrcode"];
                NSString* user_id = (NSString*)[json objectForKey:@"user_id"];
                NSNumber* placement = (NSString*) [json objectForKey:@"placement"];
                NSString* ownershipId = (NSString*)[json objectForKey:@"ownership_id"];
                [self presentSuccess];
            } else {
                NSString* error = (NSString*) [json objectForKey:@"error"];
                BOOL limitReached = [json objectForKey:@"limit_reached"];
                BOOL alreadyOwned = [json objectForKey:@"already_owned"];
                if (limitReached) {
                    // show an alert telling us the QR limit has been reached
                    //NSLog(@"QRCODE LIMIT REACHED");
                    [self presentFailure];
                }
                
                if (alreadyOwned) {
                    [self presentAlreadyOwned];
                }
                
                //NSLog(@"QRCodeSaveDelegate: connectionDidFinishLoading: %@", error);
            }
        } else {
            // should always have a success object
            // if it reaches here, something went wrong on the server
            [self presentServerFail];
        }
    } else {
        [self presentServerFail];
    }
    
}

-(void)presentSuccess {
    
    /*
    
    if ([VersionCheck IOS8ORLater]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:@"KandiTAG has been registered" preferredStyle:UIAlertControllerStyleAlert];
        [controller presentViewController:alertController animated:YES completion:^{
        }];
    } else {
     
     */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You have registered a new KandiTAG" delegate:self cancelButtonTitle:@"Dimiss" otherButtonTitles:nil];
        [alert show];

    
  /*  }  */
}

-(void)presentFailure {
    
    /*
    
    if ([VersionCheck IOS8ORLater]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Woah There!" message:@"You can no longer register this KandiTAG" preferredStyle:UIAlertControllerStyleAlert];
        [controller presentViewController:alertController animated:YES completion:^{
        }];
    } else {
     
     */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You can no longer register this KandiTAG" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    
   /* } */
}

-(void)presentAlreadyOwned {
    
    /*
     
     if ([VersionCheck IOS8ORLater]) {
     UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Woah There!" message:@"You can no longer register this KandiTAG" preferredStyle:UIAlertControllerStyleAlert];
     [controller presentViewController:alertController animated:YES completion:^{
     }];
     } else {
     
     */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hang on a Sec!" message:@"You've already owned this KandiTAG" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];

    
    /* } */
}

-(void)presentServerFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"The server is busy, please try again later" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];

}

@end
