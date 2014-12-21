//
//  FeedViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/16/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController {
    UIView *banner;
    UILabel *title;
}

@synthesize responseData;
@synthesize loadedDataSource;
@synthesize tags;
@synthesize displayType;
@synthesize json;
@synthesize tableView;


-(instancetype)initWithFlag:(DisplayType)flag {
    self = [super init];
    if (self) {
        //NSLog(@"KandiViewController init");
        responseData = [[NSMutableData alloc] init];
        loadedDataSource = NO;
        tags = [[NSMutableArray alloc] init];
        displayType = flag;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:banner];
    // Do any additional setup after loading the view.
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
