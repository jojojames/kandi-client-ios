//
//  Kandi.h
//  KandiTAG
//
//  Created by Jim Chen on 9/28/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"

@interface KandiTableViewController : UITableViewController <FBGraphUser, NSURLConnectionDataDelegate>
-(instancetype)initWithFlag:(DisplayType)flag;
-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode;
@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;

// list of all your original tags or current tags
// probably going to be a dictionary
@property (strong, nonatomic) NSMutableArray* tags;
@property (nonatomic) DisplayType displayType;

// when instantiated as detail controller, this will be set in the constructor
@property (strong, nonatomic) NSString* selectedQrCodeId;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end
