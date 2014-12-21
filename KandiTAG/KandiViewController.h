//
//  KandiViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/10/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"

@interface KandiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, FBGraphUser, UIScrollViewDelegate>

-(instancetype)initWithFlag:(DisplayType)flag;
-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode;
@property (nonatomic) DisplayType displayType;

@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;
@property (strong, nonatomic) NSMutableArray* tags;

@property (strong, nonatomic) NSString* selectedQrCodeId;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;
@property (strong, nonatomic) NSDictionary *json;

@property (strong, nonatomic) UITableView *tableView;

@end
