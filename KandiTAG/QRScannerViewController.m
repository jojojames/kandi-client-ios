//
//  ViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 9/8/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "QRBox.h"
#import "QRScannerViewController.h"


@interface QRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureVideoPreviewLayer *_previewLayer;
    QRBox *_boundingBox;
    NSTimer *_boxHideTimer;
    UILabel *_decodedMessage;
    UILabel *touch;
    UIImageView *flash;
    AVCaptureSession *session;
}

@end

@implementation QRScannerViewController
@synthesize onOffButton;
@synthesize qrCodeSaveDelegate;
@synthesize scannedCodes;

-(instancetype)init {
    self = [super init];
    if (self) {
        qrCodeSaveDelegate = [[QRCodeSaveDelegate alloc] initWithController:self];
        scannedCodes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startSession];
    
    //flashlight
    //_onOff = YES;
    
    //onOffButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //onOffButton.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:onOffButton];
    
    //[onOffButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPress)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

-(void)buttonPress {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device != nil) {
        if (!_onOff) {
            
            if ([device hasTorch] && [device hasFlash]) {
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
                [device unlockForConfiguration];
                
                [onOffButton setTitle:@"Turn off" forState:UIControlStateNormal];
                
                //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideTouch) userInfo:nil repeats:NO];
                
                touch.hidden = YES;
                
                
                
                //[self.view addSubview:onBar];
                
                //NSLog(@"flashlight is on");
            }
        } else {
            if ([device hasTorch] && [device hasFlash]) {
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                
                [device unlockForConfiguration];
                
                [onOffButton setTitle:@"Turn on" forState:UIControlStateNormal];
                
                touch.hidden = NO;
                
                //[self.view addSubview:offBar];
                
                //NSLog(@"flashlight is off");
            }
        }
    }
    
    _onOff = !_onOff;
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    onOffButton.frame = CGRectMake(self.view.frame.size.width/2 - onOffButton.frame.size.width / 2, 0, onOffButton.frame.size.width, onOffButton.frame.size.height);
}

-(void)startSession {
    
    session = [AVCaptureSession new];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // Want the normal device
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        // Add the input to the session
        [session addInput:input];
    } else {
        //NSLog(@"error: %@", error);
        return;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [session addOutput:output];
    // We're only interested in QR Codes
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // This VC is the delegate. Please call us on the main queue
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Display on screen
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.bounds = self.view.bounds;
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.layer addSublayer:_previewLayer];
    
    // Add the view to draw the bounding box for the UIView
    _boundingBox = [[QRBox alloc] initWithFrame:self.view.bounds];
    _boundingBox.backgroundColor = [UIColor clearColor];
    _boundingBox.hidden = YES;
    [self.view addSubview:_boundingBox];
    
    // Add a label to display the resultant message
    _decodedMessage = [[UILabel alloc] init];
    _decodedMessage.numberOfLines = 0;
    _decodedMessage.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    _decodedMessage.textColor = [UIColor darkGrayColor];
    _decodedMessage.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_decodedMessage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    touch = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/9, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    touch.text = @"Double Tap To Turn On Flashlight";
    touch.font = [UIFont fontWithName:@"DINCondensed-Bold" size:25];
    touch.textColor = [UIColor whiteColor];
    [self.view addSubview:touch];
    
    //start the avsession running
    //[session startRunning];
    
}

-(void)hideTouch {
    touch.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //[self startSession];
    
    [session startRunning];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            // Transform the meta-data coordinates to screen coords
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:metadata];
            // Update the frame on the _boundingBox view, and show it
            _boundingBox.frame = transformed.bounds;
            _boundingBox.hidden = NO;
            // Now convert the corners array into CGPoints in the coordinate system
            //  of the bounding box itself
            NSArray *translatedCorners = [self translatePoints:transformed.corners
                                                      fromView:self.view
                                                        toView:_boundingBox];
            
            // Set the corners array
            _boundingBox.corners = translatedCorners;
            
            // Update the view with the decoded text
            _decodedMessage.text = [transformed stringValue];
            
            /* Open kanditag.com, come back to this later
             
             //if the code is www.kanditag.com, open the link in safari
             if ([_decodedMessage.text isEqualToString:@"http://www.kanditag.com"]) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kanditag.com"]];
             NSLog(@"opening kanditag.com");
             }
             
             */
            
            NSString *dhc = @"dhc";
            //if code contains dhc
            if ([_decodedMessage.text rangeOfString:dhc].location != NSNotFound) {
                //turn decoded text into string
                NSString *ktQRcode = [[NSString alloc] initWithString:_decodedMessage.text];
                if (![scannedCodes objectForKey:ktQRcode]) {
                    [AppDelegate KandiAppDelegate].currentQrCode = ktQRcode;
                    [scannedCodes setObject:[NSNumber numberWithBool:YES] forKey:ktQRcode];
                    [[AppDelegate KandiAppDelegate].network saveQrCode:qrCodeSaveDelegate withCode:ktQRcode];
                    //NSLog(@"scanned qr: %@", ktQRcode);
                    _decodedMessage.text = @"";
                }
            }
            
            [self startOverlayHideTimer];
          
        }
    }
}

#pragma mark - Utility Methods
- (void)startOverlayHideTimer {
    // Cancel it if we're already running
    if(_boxHideTimer) {
        
        //this is causing it to crash when reading multiple qrcode
        //[_boxHideTimer invalidate];
    }
    
    // Restart it to hide the overlay when it fires
    _boxHideTimer = [NSTimer scheduledTimerWithTimeInterval:0.47
                                                     target:self
                                                   selector:@selector(removeBoundingBox:)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (void)removeBoundingBox:(id)sender {
    // Hide the box and remove the decoded text
    _boundingBox.hidden = YES;
    _decodedMessage.text = @"";
    if (_boundingBox.hidden) {
        [[AppDelegate KandiAppDelegate].network saveQrCode:qrCodeSaveDelegate];
    }
}

- (NSArray *)translatePoints:(NSArray *)points fromView:(UIView *)fromView toView:(UIView *)toView {
    NSMutableArray *translatedPoints = [NSMutableArray new];
    
    // The points are provided in a dictionary with keys X and Y
    for (NSDictionary *point in points) {
        // Let's turn them into CGPoints
        CGPoint pointValue = CGPointMake([point[@"X"] floatValue], [point[@"Y"] floatValue]);
        // Now translate from one view to the other
        CGPoint translatedPoint = [fromView convertPoint:pointValue toView:toView];
        // Box them up and add to the array
        [translatedPoints addObject:[NSValue valueWithCGPoint:translatedPoint]];
    }
    
    return [translatedPoints copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

