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
#import "ProfilePicViewController.h"


@interface QRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureVideoPreviewLayer *_previewLayer;
    QRBox *_boundingBox;
    NSTimer *_boxHideTimer;
    UILabel *_decodedMessage;
    UILabel *touch;
    UIImageView *flash;
    AVCaptureSession *session;
    UIView *viewShowingMessage;
    UIViewController *detailController;
    UIButton *dismiss;
    ProfilePicViewController *picView;
    NSTimer *removePicView;
    int attempt;
}

@end

@implementation QRScannerViewController
@synthesize qrCodeSaveDelegate;
@synthesize scannedCodes;
@synthesize loadedDataSource;
@synthesize responseData;
@synthesize tags;
@synthesize json;

#define ORIGINAL @"original"
#define CURRENT @"current"
#define QRCODE_ID @"qrcode_id"
#define USER_ID @"user_id"
#define PLACEMENT @"placement"
#define OWNERSHIP_ID @"ownership_id"
#define USER_NAME @"user_name"
#define FACEBOOK_ID @"facebookid"


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
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPress)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    responseData = [[NSMutableData alloc] init];
    loadedDataSource = NO;
    tags = [[NSMutableArray alloc] init];
        
    //flashlight
    //_onOff = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [session startRunning];
    
    [[AppDelegate KandiAppDelegate].network saveDeviceToken:self];
    
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

                touch.hidden = NO;

            }
        }
    }
    
    _onOff = !_onOff;
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
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
                    //NSString *deviceToken = [AppDelegate KandiAppDelegate].deviceToken;
                    [scannedCodes setObject:[NSNumber numberWithBool:YES] forKey:ktQRcode];
                    [[AppDelegate KandiAppDelegate].network saveQrCode:qrCodeSaveDelegate withCode:ktQRcode];
                    [[AppDelegate KandiAppDelegate].network getPreviousOwner:self withQrCode:ktQRcode];
                    //[self.view addSubview:picView.view];
                    //NSString *fbidforpic = [AppDelegate KandiAppDelegate].currentQrPicId;
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
       // [[AppDelegate KandiAppDelegate].network saveQrCode:qrCodeSaveDelegate];
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

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //if we get any connection error manage it here
    //for example use alert view to say no internet connection
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    
    // response data for the kandi REST calls always comes back as an array
    NSDictionary* jsonResponse = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
    
    NSDictionary* jsonn = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];

    
    if ([jsonn objectForKey:@"success"]) {
        NSNumber* successful = [jsonn objectForKey:@"success"];
        if ([successful boolValue]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* fbidforpic = (NSString*)[jsonn objectForKey:@"fbidforpic"];
            [defaults setObject:fbidforpic forKey:@"CURRENTQRPICID"];
            if (fbidforpic != nil) {
            picView = [[ProfilePicViewController alloc] initWithFacebookId:fbidforpic];
            [picView.view setFrame:CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, 150)];
            [picView setImageUsingFacebookId:fbidforpic];
            [self addChildViewController:picView];
            [self.view addSubview:picView.view];
                removePicView = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeProfilePicViewController) userInfo:nil repeats:NO];
            }
        }
    }
    
    if ([jsonResponse objectForKey:@"success"]) {
        NSNumber* success = [jsonResponse objectForKey:@"success"];
        if ([success boolValue]) {
            NSMutableArray* jsonArray = [jsonResponse objectForKey:@"results"];
            tags = jsonArray;
            //NSLog(@"tags: %@", tags);
            for (int i=0; i<[jsonArray count]; i++) {
                json = [jsonArray objectAtIndex:i];
                loadedDataSource = YES;
                if ([json count]) {
                    // we'll consider it a success if there's any json
                    NSDictionary* original = [json objectForKey:ORIGINAL];
                    NSDictionary* current = [json objectForKey:CURRENT];
                    
                    NSString* o_qrcodeId = [original objectForKey:QRCODE_ID];
                    NSString* o_userId = [original objectForKey:USER_ID];
                    NSString* o_placement = [original objectForKey:PLACEMENT];
                    NSString* o_ownershipId = [original objectForKey:OWNERSHIP_ID];
                    
                    NSString* c_userId = [current objectForKey:USER_ID];
                    NSString* c_userName = [current objectForKey:USER_NAME];
                    NSString* c_facebookId = [current objectForKey:FACEBOOK_ID];
                    

                }
            }
        }
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)removeProfilePicViewController {
    [picView.view removeFromSuperview];
    [picView removeFromParentViewController];
    NSLog(@"scannedCodes: %@", scannedCodes);
    NSString *currentQR = [AppDelegate KandiAppDelegate].currentQrCode;
    [scannedCodes removeObjectForKey:currentQR];
    NSLog(@"scannedCodes after set nil: %@", scannedCodes);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

