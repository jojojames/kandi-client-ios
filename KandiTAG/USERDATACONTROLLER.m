//
//  USERDATACONTROLLER.m
//  KandiTAG
//
//  Created by Jim Chen on 10/18/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "USERDATACONTROLLER.h"

@implementation USERDATACONTROLLER

@synthesize mutableData;
@synthesize dataString;

@synthesize usr;
@synthesize pw;

@synthesize FBid;
@synthesize userName;
@synthesize qrCode;
@synthesize create_date;
@synthesize original_create_date;

-(void)checkUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    FBid = [defaults stringForKey:@"FBID"];
    userName = [defaults stringForKey:@"NAME"];
    
    usr = [NSString stringWithFormat:@"jay"];
    pw = [NSString stringWithFormat:@"Libra1014"];
    
    NSLog(@"checkUser has been called");
    
    
    //need to get user_id in order to save qr code
    NSString *requestString = [NSString stringWithFormat:@"user=%@&pw=%@&fbid=%@&username=%@", usr, pw, FBid, userName];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.kanditag.com/login.php?"]];
    
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
    
    NSLog(@"user strings array: %@", strings);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:strings[0] forKey:@"USERID"];
    
    NSString *user_id = [defaults objectForKey:@"USERID"];
    
    NSLog(@"user_id: %@", user_id);
}


@end
