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
#import "Sender.h"
#import "Focus.h"

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
    ProfilePicViewController *iconView;
    NSTimer *removePicView;
    UIActivityIndicatorView *indicator;
    NSMutableArray *list;
    Sender *sender;
    Focus *focus;
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
        [self startSession];
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self startSession];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPress)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    responseData = [[NSMutableData alloc] init];
    loadedDataSource = NO;
    tags = [[NSMutableArray alloc] init];
    

    /*
     
     //this is for checking the list of available fonts
    
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
     
     */
     
   
    /*
    iconView = [[ProfilePicViewController alloc] init];
    [iconView.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self addChildViewController:iconView];
    [self.view addSubview:iconView.view];
    */
    
    //flashlight
    //_onOff = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![session isRunning])
        {
            [session startRunning];
        }
    });
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![session isRunning])
        {
            [session startRunning];
        }
    });
    
    [[AppDelegate KandiAppDelegate].network saveDeviceToken:self];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touchh = [[event allTouches] anyObject];
    CGPoint touchPoint = [touchh locationInView:touchh.view];
    [self focus:touchPoint];
    
    if (focus)
    {
        [focus removeFromSuperview];
    }

        focus = [[Focus alloc]initWithFrame:CGRectMake(touchPoint.x-40, touchPoint.y-40, 75, 75)];
        [focus setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:focus];
        [focus setNeedsDisplay];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        [focus setAlpha:0.0];
        [UIView commitAnimations];
}

- (void) focus:(CGPoint) aPoint;
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([device isFocusPointOfInterestSupported] &&
           [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            double screenWidth = screenRect.size.width;
            double screenHeight = screenRect.size.height;
            double focus_x = aPoint.x/screenWidth;
            double focus_y = aPoint.y/screenHeight;
            if([device lockForConfiguration:nil]) {
                [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                    [device setExposureMode:AVCaptureExposureModeAutoExpose];
                }
                [device unlockForConfiguration];
            }
        }
    }
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
                    [scannedCodes setObject:[NSNumber numberWithBool:YES] forKey:ktQRcode];
                    [[AppDelegate KandiAppDelegate].network saveQrCode:qrCodeSaveDelegate withCode:ktQRcode];
                    [[AppDelegate KandiAppDelegate].network getPreviousUserList:self withQrCode:ktQRcode];
                    //need to fix the backend for getPreviousUserList
                    NSLog(@"ktQrCode: %@", ktQRcode);
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
    //[self resetScannedCodesArray];
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
    

    if ([jsonResponse objectForKey:@"success"]) {
        NSNumber* success = [jsonResponse objectForKey:@"success"];
        if ([success boolValue]) {
            NSMutableArray* jsonArray = [jsonResponse objectForKey:@"results"];
            tags = jsonArray;
            //NSLog(@"jsonArray: %@", jsonArray);
            int tagsCount = tags.count;
            //NSLog(@"tags: %@", tags);
            //NSLog(@"tagscount: %d", tags.count);
                    
                list = [[NSMutableArray alloc] init];
            
                for (json in tags) {
                    sender = [Sender new];
                    sender.facebookID = [[json objectForKey:CURRENT] objectForKey:FACEBOOK_ID];
                    [list addObject:sender.facebookID];
                }
                //NSLog(@"list: %@", list);
            
                if (tags !=nil) {
                    iconView = [[ProfilePicViewController alloc] init];
                    [iconView.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                    
                    switch (tagsCount) {
                        case 1:
                            //NSLog(@"case 1");
                            [iconView setImageUsingFacebookIdfor1:list[0]];
                            break;
                        case 2:
                            //NSLog(@"case 2");
                            [iconView setImageUsingFacebookIdfor1:list[0]];
                            [iconView setImageUsingFacebookIdfor2:list[1]];
                            break;
                            
                        case 3:
                            //NSLog(@"case 3");
                            [iconView setImageUsingFacebookIdfor1:list[0]];
                            [iconView setImageUsingFacebookIdfor2:list[1]];
                            [iconView setImageUsingFacebookIdfor3:list[2]];
                            break;
                        case 4:
                            //NSLog(@"case 4");
                            [iconView setImageUsingFacebookIdfor1:list[0]];
                            [iconView setImageUsingFacebookIdfor2:list[1]];
                            [iconView setImageUsingFacebookIdfor3:list[2]];
                            [iconView setImageUsingFacebookIdfor4:list[3]];
                            break;
                        case 5:
                            //NSLog(@"case 5");
                            [iconView setImageUsingFacebookIdfor1:list[0]];
                            [iconView setImageUsingFacebookIdfor2:list[1]];
                            [iconView setImageUsingFacebookIdfor3:list[2]];
                            [iconView setImageUsingFacebookIdfor4:list[3]];
                            [iconView setImageUsingFacebookIdfor5:list[4]];
                            break;
                            
                        default:
                            break;
                    }
                    
                    [self addChildViewController:iconView];
                    [self.view addSubview:iconView.view];
                    removePicView = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeProfilePicViewController) userInfo:nil repeats:NO];
            }
        }
    }
}

-(void)removeProfilePicViewController {
    NSTimer* one = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeProfilePic1) userInfo:nil repeats:NO];
    NSTimer* two = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeProfilePic2) userInfo:nil repeats:NO];
    NSTimer* three = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeProfilePic3) userInfo:nil repeats:NO];
    NSTimer* four = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeProfilePic4) userInfo:nil repeats:NO];
    NSTimer* five = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeProfilePic5) userInfo:nil repeats:NO];
    NSTimer* final = [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(removeProfilePicViewControllerFromSuperView) userInfo:nil repeats:NO];
    NSLog(@"scannedCodes: %@", scannedCodes);
    NSString *currentQR = [AppDelegate KandiAppDelegate].currentQrCode;
    [scannedCodes removeObjectForKey:currentQR];
    NSLog(@"scannedCodes after set nil: %@", scannedCodes);
}

-(void)removeProfilePic1 {
    [iconView.profileIcon1 removeFromSuperview];
}
-(void)removeProfilePic2 {
    [iconView.profileIcon2 removeFromSuperview];
}
-(void)removeProfilePic3 {
    [iconView.profileIcon3 removeFromSuperview];
}
-(void)removeProfilePic4 {
    [iconView.profileIcon4 removeFromSuperview];
}
-(void)removeProfilePic5 {
    [iconView.profileIcon5 removeFromSuperview];
}
-(void)removeProfilePicViewControllerFromSuperView {
    [iconView.view removeFromSuperview];
    [iconView removeFromParentViewController];
}

-(void)resetScannedCodesArray {
    NSString *currentQR = [AppDelegate KandiAppDelegate].currentQrCode;
    [scannedCodes removeObjectForKey:currentQR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

