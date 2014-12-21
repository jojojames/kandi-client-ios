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

@implementation QRCodeSaveDelegate {
    UIImageView *check;
}
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
            NSLog(@"success: %@", success);
            if ([success boolValue]) {
                // QRCode was saved properly
                //NSString* qrCodeId = (NSString*)[json objectForKey:@"qrcode_id"];
                //NSString* qrCode = (NSString*)[json objectForKey:@"qrcode"];
                //NSString* user_id = (NSString*)[json objectForKey:@"user_id"];
                //NSNumber* placement = (NSString*) [json objectForKey:@"placement"];
                //NSString* ownershipId = (NSString*)[json objectForKey:@"ownership_id"];
                [self presentSuccess];
            } else {
                NSString* error = (NSString*) [json objectForKey:@"error"];
                NSNumber* limitReached = [json objectForKey:@"limit_reached"];
                NSNumber* alreadyOwned = [json objectForKey:@"already_owned"];
                NSLog(@"limitReached: %@", limitReached);
                NSLog(@"alreadyOwned: %@", alreadyOwned);
                if ([limitReached boolValue]) {
                    // show an alert telling us the QR limit has been reached
                    //NSLog(@"QRCODE LIMIT REACHED");
                    [self presentFailure];
                }
                
                if ([alreadyOwned boolValue]) {
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
    
    NSLog(@"presentSuccess");
    
 
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:@"KandiTAG has been registered" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
        [controller presentViewController:alertController animated:YES completion:^{
        }];
    
    check = [[UIImageView alloc] initWithFrame:CGRectMake(controller.view.frame.size.width/ 3, controller.view.frame.size.height / 2.6, 0, 0)];
    check.image = [UIImage imageNamed:@"check"];
    
    //[controller.view addSubview:check];
    
    NSTimer *removeCheck = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeCheck) userInfo:nil repeats:NO];

}

-(void)presentFailure {
    
    NSLog(@"presentFailure");

        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Limit Exceeded!" message:@"You can no longer register this KandiTAG" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
        [controller presentViewController:alertController animated:YES completion:^{
        }];
    
    check = [[UIImageView alloc] initWithFrame:CGRectMake(controller.view.frame.size.width/ 3, controller.view.frame.size.height / 2.6, 100, 100)];
    check.image = [UIImage imageNamed:@"error"];
    
    //[controller.view addSubview:check];
    
    NSTimer *removeCheck = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeCheck) userInfo:nil repeats:NO];

}

-(void)presentAlreadyOwned {
    
    NSLog(@"presentAlreadyOwned");
    
     UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Hang On!" message:@"This KandiTAG has already been registered to you" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
     [controller presentViewController:alertController animated:YES completion:^{
     }];
    
    
    check = [[UIImageView alloc] initWithFrame:CGRectMake(controller.view.frame.size.width/ 3, controller.view.frame.size.height / 2.6, 100, 100)];
    check.image = [UIImage imageNamed:@"check"];
    
    //[controller.view addSubview:check];
    
    NSTimer *removeCheck = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeCheck) userInfo:nil repeats:NO];

}

-(void)presentServerFail {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"The Server is busy, please try again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    [controller presentViewController:alertController animated:YES completion:^{
    }];

}

-(void)removeCheck {
    [check removeFromSuperview];
}

@end
