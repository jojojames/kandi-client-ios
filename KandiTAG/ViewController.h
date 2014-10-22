//
//  ViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "QRDataController.h"
#import "OwnershipDataController.h"
#import "OwnershipCountDC.h"

@interface ViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)buttonPressed:(id)sender;
@property (readwrite) BOOL onOff;



@end
