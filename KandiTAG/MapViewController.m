//
//  MapViewController.m
//  KandiTAG
//
//  Created by Jim Chen on 12/16/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    UILabel *banner;
    UILabel *title;
}

@synthesize currentLocation;

-(instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
        self.view.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    currentLocation = (CLLocation *)[locations lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    banner = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    banner.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:banner];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
    title.text = @"Map";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont fontWithName:@"Rancho" size:35]];
    title.textColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    [self.view addSubview:title];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 65)];
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
        
    [self.view addSubview:self.mapView];
    
    [SIOSocket socketWithHost:@"http://kandi.nodejitsu.com" response: ^(SIOSocket *socket)
     {
         self.socket = socket;
         
         __weak typeof(self) weakSelf = self;
         self.socket.onConnect = ^()
         {
             NSLog(@"mapViewController socket connected");
             weakSelf.socketIsConnected = YES;
             [weakSelf mapView: weakSelf.mapView didUpdateUserLocation: weakSelf.mapView.userLocation];
         };
         
         [self.socket on: @"join" callback: ^(SIOParameterArray *args)
          {
              [weakSelf mapView: weakSelf.mapView didUpdateUserLocation: weakSelf.mapView.userLocation];
          }];
         
         [self.socket on: @"update" callback: ^(SIOParameterArray *args)
          {
              NSLog(@"updating location socket");
              NSString *pinData = [args firstObject];
              
              NSArray *dataPieces = [pinData componentsSeparatedByString: @":"];
              NSString *pinID = [dataPieces firstObject];
              
              NSString *pinLocationString = [dataPieces lastObject];
              WPAnnotation *pin = [[WPAnnotation alloc] initWithCoordinateString: pinLocationString];
              
              if ([[self.pins allKeys] containsObject: pinID])
              {
                  CLLocationCoordinate2D newCoordinate = pin.coordinate;
                  pin = self.pins[pinID];
                  
                  pin.coordinate = newCoordinate;
                  [self.mapView removeAnnotation: pin];
              }
              
              self.pins[pinID] = pin;
              [self.mapView addAnnotation: pin];
          }];
         
         [self.socket on: @"disappear" callback: ^(SIOParameterArray *args)
          {
              NSLog(@"disappear");
              NSString *pinID = [args firstObject];
              
              [self.mapView removeAnnotation: self.pins[pinID]];
              [self.pins removeObjectForKey: pinID];
          }];
     }];

    
    // Do any additional setup after loading the view.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"pinAnnotation"];
    [pinAnnotationView setAnnotation: annotation];
    if (!pinAnnotationView)
    {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation
                                                            reuseIdentifier: @"pinAnnotation"];
    }
    
    pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Zoom to user location
    MKMapCamera *camera = [mapView.camera copy];
    camera.altitude = 1; // Zoom in
    camera.centerCoordinate = userLocation.coordinate;
    mapView.camera = camera;
    
    // Broadcast new location
    if (self.socketIsConnected)
    {
        [self.socket emit: @"location" args: @[
                                               [NSString stringWithFormat: @"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude]
                                               ]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
