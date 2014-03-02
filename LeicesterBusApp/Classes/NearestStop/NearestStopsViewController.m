//
//  NearestStopsViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "NearestStopsViewController.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "BusApiClient.h"

// Location & Annotations
#import "BusStopLocation.h"
#import "BusStopAnnotation.h"

#define METERS_PER_MILE 1609.344


@interface NearestStopsViewController ()

@end

@implementation NearestStopsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Nearest Stop";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mapView.showsUserLocation=TRUE;
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.rightBarButtonItem = [self createGPSButton];
    [self getUsersLocation];

}


- (UIBarButtonItem *)createGPSButton {
    
    UIImage *buttonImage = [UIImage imageNamed:@"gps_icon"];
    UIButton *gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gpsButton setImage:buttonImage forState:UIControlStateNormal];
    gpsButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    // Set the Target and Action for aButton
    [gpsButton addTarget:self action:@selector(btnLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gpsButton];
    
    
    return aBarButtonItem;
    
    
    
}


-(void)btnLocationClicked:(id)sender {
    [self getUsersLocation];
}


#pragma mark -
#pragma mark - Map View Delegate

- (void)getUsersLocation {
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mv.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
            region.span=span;
            region.center=location;
            
            
            NSLog(@"Location = Lat = %f, Long = %f", location.latitude, location.longitude);
            [self requestNearestStopsWithLatitude:location.latitude longitude:location.longitude];
            
            [mv setRegion:viewRegion animated:YES];;
            [mv regionThatFits:viewRegion];
            
        }
    }
}



- (void)requestNearestStopsWithLatitude:(CGFloat )lat longitude:(CGFloat )longitude {
    
    NSString *strLongitude = [NSString stringWithFormat:@"%f", longitude];
    NSString *strLatitude = [NSString stringWithFormat:@"%f", lat];
    
    // mistabus.subora.com:3000/stops?latitude=52.630365&longitude=-1.150311
    
        if ([[BusApiClient sharedInstance] isNetworkAvailable]) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           
                                           @"-1.150311", @"longitude",
                                           @"52.630365", @"latitude", nil];
            
            NSLog(@"Params %@", params);
            
            NSMutableArray *results = [NSMutableArray array];
            
            [[BusApiClient sharedInstance] commandWithParams:params apiURL:@"http://mistabus.subora.com:3000/stops"  onCompletion:^(NSDictionary *json) {
                // Loop through response to store
                for (id item in json) {
                    BusStopLocation *location = [[BusStopLocation alloc] initWithDictionary:item];
                    [results addObject:location];
                }
                
                _locationData = results;
                [self plotLocationPositions:@""];
            } onFailure:^(NSDictionary *json) {
                NSLog(@"Error ");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry we was unable to retrieve the nearest bus stops, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                
            }];
        }
}


- (void)plotLocationPositions:(NSString *)responseString {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        
        if ([annotation isKindOfClass:[BusStopLocation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (BusStopLocation *location in self.locationData) {
        
        NSNumber * latitude =  [NSNumber numberWithDouble:[location.latitude doubleValue]];
        NSNumber * longitude = [NSNumber numberWithDouble:[location.longitude doubleValue]];
        
        NSString *name = location.commonName;
        NSString *streetName = location.landMark;
        
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude =  longitude.doubleValue;
        coordinate.longitude =latitude.doubleValue;
        
        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithName:name landmark:streetName coordinate:coordinate sourceData:location];
        
       
        [self.mapView addAnnotation:annotation];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    
    pinView.animatesDrop = NO;          //YES;
    pinView.canShowCallout = YES;

    pinView.pinColor = MKPinAnnotationColorRed;
    //pinView.image = [UIImage imageNamed:@"map-icon.png"];
    
    // UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    // pinView.rightCalloutAccessoryView = rightButton;
 
    return pinView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
