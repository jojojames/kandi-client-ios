//
//  UserDataController.h
//  KandiTAG
//
//  Created by Jim Chen on 10/18/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataController : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *usr;
@property (nonatomic, strong) NSString *pw;

@property (nonatomic, strong) NSString *FBid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *qrCode;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *original_create_date;

@property (nonatomic, strong) NSMutableData *mutableData;

@property (nonatomic, strong) NSString *dataString;

-(void)checkUser;

@end
