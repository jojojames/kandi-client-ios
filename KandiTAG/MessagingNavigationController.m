//
//  MessagingNavigationController.m
//  KandiTAG
//
//  Created by Jim Chen on 11/7/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "MessagingNavigationController.h"
#import "Constants.h"

@interface MessagingNavigationController () {
    UIImageView *tag;
}

@end

@implementation MessagingNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Messaging";
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DINCondensed-Bold" size:20], NSFontAttributeName , nil]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
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
