//
//  Tag.h
//  KandiTAG
//
//  Created by Jim Chen on 9/28/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface Tag : UITableViewController <FBGraphUser>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *ktCodeArray;

@end
