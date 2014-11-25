//
//  QRScannerViewController.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeSaveDelegate.h"

@interface QRScannerViewController : UIViewController <UIAlertViewDelegate, NSURLConnectionDataDelegate>
- (IBAction)buttonPressed:(id)sender;
-(void)buttonPress;
@property (readwrite) BOOL onOff;
@property (strong, nonatomic) UIButton* onOffButton;

@property (strong, nonatomic) QRCodeSaveDelegate* qrCodeSaveDelegate;
@property (strong, nonatomic) NSMutableDictionary* scannedCodes;
@end
