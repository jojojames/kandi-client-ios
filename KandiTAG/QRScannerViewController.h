//
//  QRScannerViewController.h
//  KandiTAG
//
//  Created by James Nguyen on 10/22/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRScannerViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)buttonPressed:(id)sender;
-(void)buttonPressed;
@property (readwrite) BOOL onOff;
@property (strong, nonatomic) UIButton* onOffButton;
@end
