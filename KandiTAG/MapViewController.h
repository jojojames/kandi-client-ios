//
//  MapViewController.h
//  KandiTAG
//
//  Created by Jim Chen on 12/16/14.
//  Copyright (c) 2014 Jim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIOSocket/SIOSocket.h>
#import <MapKit/MapKit.h>
#import "WPAnnotation.h"
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, NSURLConnectionDataDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) SIOSocket *socket;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic) BOOL socketIsConnected;

@property (nonatomic, strong) NSMutableDictionary *pins;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property CLLocation *currentLocation;

-(instancetype)init;

@end
