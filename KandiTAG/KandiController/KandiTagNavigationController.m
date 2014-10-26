//
//  KandiTagNavigationController.m
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiTagNavigationController.h"
#import "Constants.h"

@interface KandiTagNavigationController ()

@end

@implementation KandiTagNavigationController
@synthesize tableView;

-(instancetype)initWithFlag:(DisplayType)flag {
    self = [super init];
    if (self) {
        self.tableView = [[KandiTableViewController alloc] initWithFlag:flag];
        [self pushViewController:self.tableView animated:NO];
        self.navigationBar.translucent = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
