//
//  VersionCheck.m
//  KandiTAG
//
//  Created by James Nguyen on 10/25/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "VersionCheck.h"

@implementation VersionCheck

+(BOOL)IOS8ORLater {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        return YES;
    } else {
        return NO;
    }
}


@end
