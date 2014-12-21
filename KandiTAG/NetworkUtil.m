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
    NSLog(@"Requesting Login");
    NSString* facebookId = [AppDelegate KandiAppDelegate].facebookId;
    NSString* userName = [AppDelegate KandiAppDelegate].userName;
    
    if (!facebookId || !userName )
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

-(void)saveDeviceToken:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"saveDeviceToken");
    NSString* token = [AppDelegate KandiAppDelegate].deviceToken;
    NSString* facebookid = [AppDelegate KandiAppDelegate].facebookId;
    NSString* userName = [AppDelegate KandiAppDelegate].userName;
    NSInteger badgeN = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    NSNumber *badgeNum = [NSNumber numberWithInteger:badgeN];
    
    //NSLog(@"badgeNum: %@", badgeNum);
    
    if (!token)
        return;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:token forKey:@"token"];
    [dict setObject:facebookid forKey:@"facebookid"];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:badgeNum forKey:@"badgenum"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/token", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)createFollowCollection:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"createFollowCollection");
    NSString *userID = [AppDelegate KandiAppDelegate].mainUserId;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userID forKey:@"userID"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/follow", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];

}

-(void)getFollowers:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"getFollowers");
    NSString *userID = [AppDelegate KandiAppDelegate].mainUserId;
    if (!userID)
        return;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userID forKey:@"user_id"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/followers", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getFollowing:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"getFollowing");
    NSString *userID = [AppDelegate KandiAppDelegate].mainUserId;
    if (!userID)
        return;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:userID forKey:@"user_id"];
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/following", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)saveQr:(id<NSURLConnectionDataDelegate>)netdelegate withQrCode:(NSString *)code {
    NSLog(@"saveQr");
    NSString *user_id = [AppDelegate KandiAppDelegate].mainUserId;
    NSString *username = [AppDelegate KandiAppDelegate].userName;
    if (!code) {
        return;
    }
    
    NSError *error;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:code forKey:@"qrcode"];
    [dict setObject:user_id forKey:@"user_id"];
    [dict setObject:username forKey:@"username"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/qrcodes", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate {
    NSString* qrCode = [AppDelegate KandiAppDelegate].currentQrCode;
    [self saveQrCode:netdelegate withCode:qrCode];
}

-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate withCode:(NSString*)qrCode {
    NSLog(@"saveQrCode");
    NSString* user_id = [AppDelegate KandiAppDelegate].mainUserId;
    NSString* user_name = [AppDelegate KandiAppDelegate].userName;
    
    if (!qrCode || !user_id)
        return;
    
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:qrCode forKey:@"qrcode"];
    [dict setObject:user_id forKey:@"user_id"];
    [dict setObject:user_name forKey:@"username"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/qr", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getOriginalTags:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"getOriginalTags");
    NSString* user_id = [AppDelegate KandiAppDelegate].mainUserId;
    
    if (!user_id)
        return;
    
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
    NSLog(@"getCurrentTags");
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
    NSLog(@"getAllTags");
    
    NSError* error;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:code forKey:@"qrcode_id"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/alltags", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getPreviousOwner:(id<NSURLConnectionDataDelegate>)netdelegate withQrCode:(NSString *)code {
    NSLog(@"getPreviousOwner");
    if (!code)
        return;
    
    NSError *error;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:code forKey:@"qrcode"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/previouspic", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getPreviousUserList:(id<NSURLConnectionDataDelegate>)netdelegate withQrCode:(NSString *)code {
    NSLog(@"getPreviousUserList");
    if (!code)
        return;
    NSError *error;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:code forKey:@"qrcode"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONReadingAllowFragments error:&error];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/previoususerlist", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

# pragma mark - messaging

-(void)sendMessage:(id<NSURLConnectionDataDelegate>)netdelegate withMessage:(NSString *)message andRecipient:(NSString *)recipient andTime:(NSString *)timestamp {
    NSString *user_id = [AppDelegate KandiAppDelegate].facebookId;
    NSString *user_name = [AppDelegate KandiAppDelegate].userName;
    
    if (!message || !recipient || !timestamp) {
        return;
    }
    
    NSLog(@"sendMessage");
    
    NSError *error;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:message forKey:@"message"];
    [dict setObject:user_id forKey:@"sender"];
    [dict setObject:recipient forKey:@"recipient"];
    [dict setObject:timestamp forKey:@"timestamp"];
    [dict setObject:user_name forKey:@"username"];

    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/sendmessage", host];
    
    [self postRequestWithURL:requestURL andData:requestData withDelegate:netdelegate];
    
}

-(void)getAllMessages:(id<NSURLConnectionDataDelegate>)netdelegate {
    NSLog(@"getAllMessages");
    NSString *user_id = [AppDelegate KandiAppDelegate].facebookId;
    if (!user_id) {
        return;
    }
    
    NSError *error;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:user_id forKey:@"sender"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/allmessages", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)getMessageExchange:(id<NSURLConnectionDataDelegate>)netdelegate withRecipient:(NSString *)recipient {
    NSLog(@"getMessageExchange");
    if (!recipient) {
        return;
    }
    
    NSString *user_id = [AppDelegate KandiAppDelegate].facebookId;
    
    NSError *error;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:recipient forKey:@"recipient"];
    [dict setObject:user_id forKey:@"sender"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/messagehistory", host];
    [self postRequestWithURL:requestUrl andData:requestData withDelegate:netdelegate];
}

-(void)saveConvo:(id<NSURLConnectionDataDelegate>)netdelegate withMessage:(NSString *)message andRecipient:(NSString *)recipient andName:(NSString *)name {
    if (!message || !recipient || !name) {
        return;
    }
    NSLog(@"saveConvo");
    
    NSString *user_id = [AppDelegate KandiAppDelegate].facebookId;
    NSString *user_name = [AppDelegate KandiAppDelegate].userName;
    
    NSError *error;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:user_id forKey:@"sender"];
    [dict setObject:recipient forKey:@"recipient"];
    [dict setObject:message forKey:@"message"];
    [dict setObject:user_name forKey:@"myname"];
    [dict setObject:name forKey:@"username"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/saveconvo", host];
    
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
