//
//  MessageSendDelegate.m
//  KandiTAG
//
//  Created by Jim Chen on 11/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "MessageSendDelegate.h"
#import "AppDelegate.h"

@implementation MessageSendDelegate

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
                //NSString* qrCodeId = (NSString*)[json objectForKey:@"qrcode_id"];
                //NSString* qrCode = (NSString*)[json objectForKey:@"qrcode"];
                //NSString* user_id = (NSString*)[json objectForKey:@"user_id"];
                //NSNumber* placement = (NSString*) [json objectForKey:@"placement"];
                //NSString* ownershipId = (NSString*)[json objectForKey:@"ownership_id"];
                
                //strings for messages
                //NSString *message = (NSString *)[json objectForKey:@"message"];
                
                [self presentSuccess];
            } else {
                NSString* error = (NSString*) [json objectForKey:@"error"];
                BOOL limitReached = [json objectForKey:@"limit_reached"];
                if (limitReached) {
                    // show an alert telling us the QR limit has been reached
                    //NSLog(@"QRCODE LIMIT REACHED");
                    [self presentFailure];
                }
                
                //NSLog(@"QRCodeSaveDelegate: connectionDidFinishLoading: %@", error);
            }
        } else {
            // should always have a success object
            // if it reaches here, something went wrong on the server
            [self presentFailure];
        }
    } else {
        [self presentFailure];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"KandiTAG has been registered" delegate:self cancelButtonTitle:@"Proceed" otherButtonTitles:nil];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woah There!" message:@"You can no longer register this KandiTAG" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    /* } */
}

@end
