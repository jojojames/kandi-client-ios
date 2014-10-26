//
//  QRCodeSaveDelegate.h
//  KandiTAG
//
//  Created by James Nguyen on 10/24/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeSaveDelegate : NSObject <NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) UIViewController* controller;
-(instancetype)initWithController:(UIViewController*)parent;
@end
