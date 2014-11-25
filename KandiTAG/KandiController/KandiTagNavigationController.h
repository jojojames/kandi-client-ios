//
//  KandiTagNavigationController.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KandiTableViewController.h"

@interface KandiTagNavigationController : UINavigationController

-(instancetype)initWithFlag:(DisplayType)flag;
@property (strong, nonatomic) KandiTableViewController* tableView;

@end
