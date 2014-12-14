//
//  DetailPageController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/13/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Constants.h"

@interface DetailPageController : UIPageViewController <NSURLConnectionDataDelegate, FBGraphUser, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

-(instancetype)initWithFlag:(DisplayType)flag;
-(instancetype)initWithFlag:(DisplayType)flag andQRCode:(NSString*)qrCode andTransitionStyle:(UIPageViewControllerTransitionStyle)transitionStyle;
@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;

@property (strong, nonatomic) UICollectionView *collectionView;
// list of all your original tags or current tags
// probably going to be a dictionary
@property (strong, nonatomic) NSMutableArray* tags;
@property (nonatomic) DisplayType displayType;

// when instantiated as detail controller, this will be set in the constructor
@property (strong, nonatomic) NSString* selectedQrCodeId;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;
@property (strong, nonatomic) NSDictionary *json;

@end
