//
//  MessageSendDelegate.h
//  KandiTAG
//
//  Created by Jim Chen on 11/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageSendDelegate : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) UIViewController* controller;
-(instancetype)initWithController:(UIViewController*)parent;

@end
