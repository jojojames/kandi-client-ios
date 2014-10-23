//
//  KandiTagNavigationController.m
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "KandiTagNavigationController.h"

@interface KandiTagNavigationController ()

@end

@implementation KandiTagNavigationController
@synthesize tableView;

-(instancetype)init {
    self = [super init];
    if (self) {
        self.tableView = [[UITableViewController alloc] init];
        self.tableView.view.backgroundColor = [UIColor redColor];
        [self pushViewController:self.tableView animated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
