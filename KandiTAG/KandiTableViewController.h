//
//  Kandi.h
//  KandiTAG
//
//  Created by Jim Chen on 9/28/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "KandiDataController.h"

@interface KandiTableViewController : UITableViewController <FBGraphUser>
-(instancetype)initWithFlag:(NSString*)flag;
@property (nonatomic) BOOL isKandi;

@end
