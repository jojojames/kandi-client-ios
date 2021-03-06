//
//  ProfileViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/17/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

-(instancetype)initWithUserName:(NSString*)username andFbId:(NSString*)fbid andController:(UIViewController*)parent;

@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic) BOOL hasImage;

@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;
@property (strong, nonatomic) NSMutableArray* tags;
@property (strong, nonatomic) NSDictionary *json;

@property (strong, nonatomic) UICollectionView *following;
@property (strong, nonatomic) UICollectionView *followers;

@property (nonatomic, retain) UICollectionViewLayout *collectionViewLayout;

@end
