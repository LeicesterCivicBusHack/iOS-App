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
            
            // Testing
          //  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 1.5*METERS_PER_MILE, 1.5*METERS_PER_MILE);
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
    
        if ([[BusApiClient sharedInstance] isNetworkAvailable]) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"nearest",@"command",
                                           strLatitude, @"long",
                                           strLongitude, @"lat", nil];
            
            NSLog(@"Params %@", params);
            
            [[BusApiClient sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
                NSLog(@"Json Response %@", json);
            }];
        }
        
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
