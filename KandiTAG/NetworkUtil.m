//
//  NetworkUtil.m
//  KandiTAG
//
//  Created by James Nguyen on 10/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "NetworkUtil.h"
#import "AppDelegate.h"

@implementation NetworkUtil
@synthesize mainConnection;
@synthesize mutableData;
@synthesize host;

-(instancetype)init {
    self = [super init];
    if (self) {
        host = @"http://kandi.nodejitsu.com";
    }
    return self;
}

-(void)requestLogin:(id<NSURLConnectionDataDelegate>) netdelegate {
    NSString* facebookId = [AppDelegate KandiAppDelegate].facebookId;
    NSString* userName = [AppDelegate KandiAppDelegate].userName;
    
    if (!facebookId || !userName)
        return;
    
    //need to get user_id in order to save qr code
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:facebookId forKey:@"facebookid"];
    [dict setObject:userName forKey:@"username"];
    NSError* error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/login", host];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:netdelegate startImmediately:NO];
    [connection start];
}

-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate {
    NSString* qrCode = [AppDelegate KandiAppDelegate].currentQrCode;
    NSString* user_id = [AppDelegate KandiAppDelegate].mainUserId;
    
    if (!qrCode || !user_id)
        return;
    
    NSLog(@"checkQR has been called");
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:qrCode forKey:@"qrcode"];
    [dict setObject:user_id forKey:@"user_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/qr", host];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:netdelegate startImmediately:NO];
    [connection start];
}

@end
