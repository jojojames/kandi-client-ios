//
//  QRScannerViewController.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeSaveDelegate.h"

@interface QRScannerViewController : UIViewController <UIAlertViewDelegate, NSURLConnectionDataDelegate, FBGraphUser>

@property (readwrite) BOOL onOff;
@property (strong, nonatomic) QRCodeSaveDelegate* qrCodeSaveDelegate;
@property (strong, nonatomic) NSMutableDictionary* scannedCodes;

@property (strong, nonatomic) NSMutableData* responseData;
@property (nonatomic) BOOL loadedDataSource;
@property (strong, nonatomic) NSMutableArray* tags;
@property (strong, nonatomic) NSDictionary *json;

-(void)buttonPress;

-(instancetype)init;

@end
