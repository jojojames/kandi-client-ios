//
//  OWNERSHIPDATACONTROLLER.m
//  KandiTAG
//
//  Created by Jim Chen on 10/19/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "OWNERSHIPDATACONTROLLER.h"

@implementation OWNERSHIPDATACONTROLLER

@synthesize mutableData;
@synthesize dataString;

@synthesize usr;
@synthesize pw;

@synthesize FBid;
@synthesize userName;
@synthesize qrCode;
@synthesize create_date;
@synthesize original_create_date;

@synthesize user_id;
@synthesize qrcode_id;
@synthesize ownership_id;

-(void)checkOwnership {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    qrCode = [defaults stringForKey:@"QRCODE"];
    create_date = [defaults stringForKey:@"CREATE_AT"];
    original_create_date = [defaults stringForKey:@"ORIGINAL_CREATE_AT"];
    user_id = [defaults stringForKey:@"USERID"];
    qrcode_id = [defaults stringForKey:@"QRCODEID"];
    
    usr = [NSString stringWithFormat:@"jay"];
    pw = [NSString stringWithFormat:@"Libra1014"];
    
    NSLog(@"checkOwnership has been called");
    
    
    //need to get user_id in order to save qr code
    NSString *requestString = [NSString stringWithFormat:@"user=%@&pw=%@&qrcodeid=%@&userid=%@&create_at=%@&original_create_at=%@", usr, pw, qrcode_id, user_id, create_date, original_create_date];
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.kanditag.com/ownership.php?"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

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
    
    NSArray *strings = [string componentsSeparatedByString:@", "];
    
    NSLog(@"ownership strings array: %@", strings);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:strings[0] forKey:@"OWNERSHIPID"];
    
    ownership_id = [defaults objectForKey:@"OWNERSHIPID"];
    
    NSLog(@"ownership_id: %@", ownership_id);
    
}

@end
