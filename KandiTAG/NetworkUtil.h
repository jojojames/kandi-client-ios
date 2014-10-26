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
-(void)saveQrCode:(id<NSURLConnectionDataDelegate>) netdelegate withCode:(NSString*)code;
-(void)getOriginalTags:(id<NSURLConnectionDataDelegate>) netdelegate;
-(void)getCurrentTags:(id<NSURLConnectionDataDelegate>) netdelegate;
-(void)getAllTags:(id<NSURLConnectionDataDelegate>) netdelegate withQRcode:(NSString*)code;
@end
