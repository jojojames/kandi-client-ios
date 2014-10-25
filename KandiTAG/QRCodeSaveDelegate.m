//
//  QRCodeSaveDelegate.m
//  KandiTAG
//
//  Created by James Nguyen on 10/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "QRCodeSaveDelegate.h"

@implementation QRCodeSaveDelegate
@synthesize responseData;

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
        NSString* success = (NSString*)[json objectForKey:@"success"];
        if ([json objectForKey:@"qrcode_limit_reached"]) {
            // limit has been reached for qrcode
        } else {
            if ([json objectForKey:@"qrcode_id"]) {
                NSString* qrcodeId = (NSString*)[json objectForKey:@"qrcode_id"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRCODEID"];
                [[NSUserDefaults standardUserDefaults] setObject:qrcodeId forKey:@"QRCODEID"];
            }
        }
        
    } else {
        // should always have a success object
        // if it reaches here, something went wrong on the server
    }
    

}

@end
