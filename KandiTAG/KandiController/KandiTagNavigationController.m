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
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:247.0f/255.0 alpha:0.97f]];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:102.0f/255.0 alpha:0.57f]];
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DINCondensed-Bold" size:22], NSFontAttributeName , nil]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0 green:150.0f/255.0 blue:255.0f/255.0 alpha:1.0f]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
