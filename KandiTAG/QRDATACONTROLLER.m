//
//  QRDATACONTROLLER.m
//  KandiTAG
//
//  Created by Jim Chen on 10/18/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "QRDATACONTROLLER.h"

@implementation QRDATACONTROLLER

@synthesize mutableData;
@synthesize dataString;

@synthesize usr;
@synthesize pw;

@synthesize user_id;

@synthesize FBid;
@synthesize userName;
@synthesize qrCode;
@synthesize create_date;
@synthesize original_create_date;

-(void)checkQR {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    FBid = [defaults stringForKey:@"FBID"];
    userName = [defaults stringForKey:@"NAME"];
    qrCode = [defaults stringForKey:@"QRCODE"];
    user_id = [defaults stringForKey:@"USERID"];
    
    
    usr = [NSString stringWithFormat:@"jay"];
    pw = [NSString stringWithFormat:@"Libra1014"];
    
    NSLog(@"checkQR has been called");
    
    
    //need to get user_id in order to save qr code
    NSString *requestString = [NSString stringWithFormat:@"user=%@&pw=%@&qrcode=%@&userid=%@", usr, pw, qrCode, user_id];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.kanditag.com/qr.php?"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    //needs to return the kt_qrcode id
    if (connection)
    {
        mutableData = [[NSMutableData alloc] init];
    }
    
}

#pragma mark - NSURLConnection Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [mutableData setLength:0];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [mutableData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //if we get any connection error manage it here
    //for example use alert view to say no internet connection
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSMutableString *string = [[NSMutableString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    
    NSArray *strings = [string componentsSeparatedByString:@" - "];
    
    NSLog(@"qr strings array: %@", strings);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QRCODEID"];
    
    [defaults setObject:strings[0] forKey:@"QRCODEID"];
    
    NSString *qrcode_id = [defaults objectForKey:@"QRCODEID"];
    
    NSLog(@"qrcode_id: %@", qrcode_id);
}

@end
