//
//  Ownership.h
//  KandiTAG
//
//  Created by Jim Chen on 10/16/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ownership : NSObject

@property (nonatomic, strong) NSString *uniqueIDownership;
@property (nonatomic, strong) NSString *qrcode_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *created_at;

@end
