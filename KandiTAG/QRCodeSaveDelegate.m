//
//  QRCodeSaveDelegate.m
//  KandiTAG
//
//  Created by James Nguyen on 10/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "QRCodeSaveDelegate.h"
#import "VersionCheck.h"
#import "AppDelegate.h"

@implementation QRCodeSaveDelegate
@synthesize responseData;
@synthesize showingAlert;

#pragma mark - NSURLConnection Delegate

-(instancetype)init {
    self = [super init];
    if (self) {
        self.responseData = [[NSMutableData alloc] init];
        self.showingAlert = NO;
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
        } else {
            NSString* error = (NSString*) [json objectForKey:@"error"];
            BOOL limitReached = [json objectForKey:@"limit_reached"];
            if (limitReached) {
                // show an alert telling us the QR limit has been reached
                NSLog(@"QRCODE LIMIT REACHED");
                if ([VersionCheck IOS8ORLater]) {
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Save Failed" message:@"This tag has been saved too many times" preferredStyle:UIAlertControllerStyleAlert];
                    [[AppDelegate KandiAppDelegate].window.rootViewController presentViewController:alertController animated:YES completion:^{
                    }];
                    
                } else {
                    
                }
            }
            
            NSLog(@"QRCodeSaveDelegate: connectionDidFinishLoading: %@", error);
        }
    } else {
        // should always have a success object
        // if it reaches here, something went wrong on the server
    }
    

}

@end
