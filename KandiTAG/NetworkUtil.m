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
    
    //facebookId = [NSString stringWithFormat:@"Custom1_%@", facebookId];
    //userName = [NSString stringWithFormat:@"Custom1_%@", userName];
    /*
   
    facebookId = @"100008421902023";
    userName = @"John Qkgujgf";
    
    
    facebookId = @"100007313506657";
    userName = @"Bill Qkgujgf";
    
    
    facebookId = @"100007116706642";
    userName = @"Linda Qkgujgf";
    
    
    facebookId = @"100004751116722";
    userName = @"James Qkgujgf";
    
    
    facebookId = @"100008421572029";
    userName = @"Bob Well";
    
    
    facebookId = @"100005724196611";
    userName = @"Mary Fitzzzs";
    
    
    facebookId = @"100005652436668";
    userName = @"Dave Quccaut";
    
    
    facebookId = @"100005138056644";
    userName = @"Lisa Mlazn";
    
    */
    
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
    [self saveQrCode:netdelegate withCode:qrCode];
}

-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate withCode:(NSString*)qrCode {
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
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getOriginalTags:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSString* user_id = [AppDelegate KandiAppDelegate].mainUserId;
    
    if (!user_id)
        return;
    
    NSLog(@"checkQR has been called");
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:user_id forKey:@"user_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/originaltags", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getCurrentTags:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"getCurrentTags has been called");
    NSString* user_id = [AppDelegate KandiAppDelegate].mainUserId;
    
    if (!user_id)
        return;
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:user_id forKey:@"user_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/currenttags", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getAllTags:(id<NSURLConnectionDataDelegate>) netdelegate withQRcode:(NSString*)code {
    if (!code)
        return;
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:code forKey:@"qrcode_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/alltags", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)postRequestWithURL:(NSString*)url andData:(NSData*)requestData withDelegate:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:requestData];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:netdelegate startImmediately:NO];
    [connection start];
}


@end
