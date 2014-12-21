//
//  FeedViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/16/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(instancetype)initWithFlag:(DisplayType)flag;

@property (nonatomic) DisplayType displayType;

@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;
@property (strong, nonatomic) NSMutableArray* tags;

@property (strong, nonatomic) NSString* selectedQrCodeId;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;
@property (strong, nonatomic) NSDictionary *json;
@property (nonatomic, strong) UITableView *tableView;


@end
