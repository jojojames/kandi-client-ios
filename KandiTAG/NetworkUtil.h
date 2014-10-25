//
//  NetworkUtil.h
//  KandiTAG
//
//  Created by James Nguyen on 10/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtil : NSObject <NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSURLConnection * mainConnection;
@property (strong, nonatomic) NSMutableData* mutableData;
@property (strong, nonatomic) NSString* host;

-(void)requestLogin:(id<NSURLConnectionDataDelegate>) netdelegate;
-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate;
-(void)checkOwnership:(id<NSURLConnectionDataDelegate>) netdelegate;
-(void)checkOwnershipCount:(id<NSURLConnectionDataDelegate>) netDelegate;
@end
